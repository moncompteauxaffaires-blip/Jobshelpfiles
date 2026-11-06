-- JobsHelp PostgreSQL schema V1 (proposition de départ)
-- À relire, migrer et tester avant toute utilisation en production.
-- Aucun secret Stripe ni IBAN brut ne doit être stocké dans ces tables.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE app_users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL UNIQUE,
  password_hash text,
  full_name text NOT NULL DEFAULT '',
  backup_email text,
  phone text,
  email_verified_at timestamptz,
  phone_verified_at timestamptz,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE user_roles (
  user_id uuid NOT NULL REFERENCES app_users(id) ON DELETE CASCADE,
  role text NOT NULL CHECK (role IN ('admin', 'seller', 'buyer')),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, role)
);

CREATE TABLE seller_accounts (
  user_id uuid PRIMARY KEY REFERENCES app_users(id) ON DELETE CASCADE,
  provider_account_id text UNIQUE,
  onboarding_complete boolean NOT NULL DEFAULT false,
  payouts_enabled boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  parent_id uuid REFERENCES categories(id) ON DELETE SET NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  seller_id uuid NOT NULL REFERENCES app_users(id),
  category_id uuid NOT NULL REFERENCES categories(id),
  title text NOT NULL,
  description text NOT NULL DEFAULT '',
  file_format text NOT NULL CHECK (file_format IN ('PDF', 'ZIP', 'EPUB', 'MP4')),
  price_minor bigint NOT NULL CHECK (price_minor >= 0),
  currency char(3) NOT NULL DEFAULT 'EUR',
  status text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'pending', 'approved', 'rejected', 'archived')),
  cover_storage_key text,
  reviewed_by uuid REFERENCES app_users(id) ON DELETE SET NULL,
  reviewed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX products_public_catalog_idx ON products(category_id, created_at DESC) WHERE status = 'approved';
CREATE INDEX products_seller_idx ON products(seller_id, created_at DESC);

CREATE TABLE product_files (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  storage_key text NOT NULL UNIQUE,
  original_filename text NOT NULL,
  verified_mime_type text NOT NULL,
  size_bytes bigint NOT NULL CHECK (size_bytes > 0),
  sha256_hex char(64),
  scan_status text NOT NULL DEFAULT 'pending' CHECK (scan_status IN ('pending', 'clean', 'rejected')),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE favorites (
  user_id uuid NOT NULL REFERENCES app_users(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, product_id)
);

CREATE TABLE carts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE REFERENCES app_users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE cart_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cart_id uuid NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES products(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (cart_id, product_id)
);

CREATE TABLE orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  buyer_id uuid NOT NULL REFERENCES app_users(id),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'failed', 'partially_refunded', 'refunded', 'cancelled')),
  currency char(3) NOT NULL DEFAULT 'EUR',
  subtotal_minor bigint NOT NULL CHECK (subtotal_minor >= 0),
  total_minor bigint NOT NULL CHECK (total_minor >= 0),
  idempotency_key text NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX orders_buyer_idx ON orders(buyer_id, created_at DESC);

CREATE TABLE order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(id) ON DELETE RESTRICT,
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
  seller_id uuid NOT NULL REFERENCES app_users(id) ON DELETE RESTRICT,
  product_title_snapshot text NOT NULL,
  unit_amount_minor bigint NOT NULL CHECK (unit_amount_minor >= 0),
  seller_share_minor bigint NOT NULL CHECK (seller_share_minor >= 0),
  platform_share_minor bigint NOT NULL CHECK (platform_share_minor >= 0),
  referrer_share_minor bigint NOT NULL DEFAULT 0 CHECK (referrer_share_minor >= 0),
  commission_scheme text NOT NULL CHECK (commission_scheme IN ('phase1_50_50', 'phase2_referral_25_75')),
  created_at timestamptz NOT NULL DEFAULT now(),
  CHECK (seller_share_minor + platform_share_minor + referrer_share_minor <= unit_amount_minor)
);

CREATE INDEX order_items_order_idx ON order_items(order_id);
CREATE INDEX order_items_seller_idx ON order_items(seller_id, created_at DESC);

CREATE TABLE payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(id) ON DELETE RESTRICT,
  provider text NOT NULL DEFAULT 'stripe',
  provider_payment_id text UNIQUE,
  amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
  currency char(3) NOT NULL,
  status text NOT NULL CHECK (status IN ('requires_payment', 'processing', 'succeeded', 'failed', 'refunded', 'partially_refunded')),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE processed_webhook_events (
  provider_event_id text PRIMARY KEY,
  event_type text NOT NULL,
  processed_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE refunds (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  payment_id uuid NOT NULL REFERENCES payments(id) ON DELETE RESTRICT,
  amount_minor bigint NOT NULL CHECK (amount_minor > 0),
  reason text,
  status text NOT NULL CHECK (status IN ('pending', 'succeeded', 'failed')),
  provider_refund_id text UNIQUE,
  created_by uuid REFERENCES app_users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE payout_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  seller_id uuid NOT NULL REFERENCES app_users(id),
  amount_minor bigint NOT NULL CHECK (amount_minor > 0),
  currency char(3) NOT NULL DEFAULT 'EUR',
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'paid', 'rejected', 'failed')),
  provider_transfer_id text UNIQUE,
  reviewed_by uuid REFERENCES app_users(id) ON DELETE SET NULL,
  reviewed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX payout_requests_seller_idx ON payout_requests(seller_id, created_at DESC);

CREATE TABLE download_grants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_item_id uuid NOT NULL REFERENCES order_items(id) ON DELETE RESTRICT,
  buyer_id uuid NOT NULL REFERENCES app_users(id) ON DELETE RESTRICT,
  expires_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (order_item_id, buyer_id)
);

CREATE TABLE download_audit (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  grant_id uuid NOT NULL REFERENCES download_grants(id) ON DELETE RESTRICT,
  downloaded_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE audit_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_user_id uuid REFERENCES app_users(id) ON DELETE SET NULL,
  action text NOT NULL,
  resource_type text NOT NULL,
  resource_id uuid,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX audit_log_resource_idx ON audit_log(resource_type, resource_id, created_at DESC);

-- Important : les contraintes de transition d'état, le calcul du solde disponible,
-- les politiques d'accès et les migrations doivent être complétés côté application,
-- puis vérifiés par tests. Ne pas exposer les tables directement au navigateur.
