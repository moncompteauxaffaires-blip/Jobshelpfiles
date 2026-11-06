# Architecture JobsHelp

## Vue d’ensemble

La plateforme JobsHelp est une marketplace de fichiers numériques avec 3 principaux acteurs :
- Admin
- Vendeur
- Acheteur

## Couches applicatives

### 1. Frontend
- Interface web pour les acheteurs, vendeurs et admin
- Dashboard vendeur
- Dashboard admin
- Page produit
- Panier et checkout

### 2. Backend API
- Gestion utilisateurs
- Gestion produits
- Gestion commande
- Gestion paiement
- Gestion remboursements
- Gestion commissions
- Gestion fichiers

### 3. Stockage fichiers
- Stockage privé
- Accès contrôlé après paiement confirmé
- Validation avant publication

### 4. Paiements
- Stripe Checkout ou Stripe Payment Intents
- Stripe Connect pour les versements vendeurs
- Environnement test avant production

### 5. Base de données
- PostgreSQL comme base principale
- Tables pour comptes, produits, paniers, commandes, paiements, commissions, remboursements

## Flux majeurs

### Inscription
User -> register -> verify email/phone -> role assignment -> profile creation

### Publication produit
Seller -> upload file -> metadata -> admin validation -> published

### Achat produit
Buyer -> add to cart -> checkout -> payment -> order created -> file access authorized

### Versement vendeur
Order paid -> commission calculation -> payout request -> admin approval -> transfer via IBAN / Stripe

## Sécurité

- BCrypt / argon2 pour mot de passe
- JWT ou session sécurisée
- Rôles et permissions stricts
- Validation des fichiers
- Aucune donnée bancaire dans le dépôt public
- Accès aux fichiers limité au paiement confirmé

## Déploiement recommandé

- Frontend : Vercel
- Backend : Render / Railway / VPS
- Base : Supabase / Neon / managed PostgreSQL
- Storage : S3 compatible / Supabase Storage
- Monitoring : logs + alertes
