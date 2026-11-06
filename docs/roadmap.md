# Roadmap JobsHelp

## Phase 0 — préparation

- Valider les spécifications
- Définir les rôles : admin, vendeur, acheteur
- Choisir la stack technique
- Préparer GitHub et branche principale
- Créer le dépôt de travail

## Phase 1 — comptes et sécurité

- Inscription / connexion
- Récupération de mot de passe
- Vérification e-mail et téléphone
- Gestion des rôles
- Profil utilisateur
- Protection des données sensibles

### Livrables
- Auth service
- User profile
- Role-based access control
- Sessions sécurisées

## Phase 2 — catalogue et fichiers

- Catégories
- Formats autorisés : PDF, ZIP, EPUB, MP4
- Ajout de produits
- Description, images, prix
- Validation admin
- Stockage privé

### Livrables
- Product module
- File upload service
- Admin moderation
- Product metadata

## Phase 3 — achats et paiements

- Panier multi-articles
- Checkout unique
- Paiement par carte
- Stripe Connect
- Historique des transactions
- Confirmation automatique

### Livrables
- Cart service
- Order service
- Payment integration
- Payment status tracking

## Phase 4 — téléchargements et historique

- Vérification paiement validé
- Autorisation de téléchargement
- Historique achats
- Favoris
- Gestion des retours / remboursements

### Livrables
- Download access control
- Purchase history
- Wishlist/favorites
- Refund workflow

## Phase 5 — vendeur et admin

- Dashboard vendeur
- Chiffre d’affaires
- Commissions
- Demande de versement
- Dashboard admin
- Gestion des comptes et catégories

### Livrables
- Seller dashboard
- Admin dashboard
- Payout module
- Commission calc engine

## Phase 6 — production

- Tests fonctionnels
- Tests de sécurité
- Tests de paiement en environnement sandbox
- Audit final
- Mise en production contrôlée

## Règles

- Ne jamais activer le vrai paiement avant validation complète
- Ne jamais stocker de secrets dans le dépôt public
- Prioriser une montée en charge sécurisée
- Sauvegarder le code régulièrement
