# API JobsHelp — proposition V1

Préfixe : `/api/v1`. Les exemples sont une spécification de routes, pas encore des endpoints implémentés.

## Conventions

- JSON en entrée/sortie, sauf téléversement direct vers le stockage privé via URL signée courte durée.
- Authentification par session sécurisée ; vérification d’autorisation sur le serveur à chaque requête.
- Erreurs structurées : `{ "error": { "code": "...", "message": "..." } }`.
- Pagination par curseur pour listes volumineuses.
- Idempotence obligatoire pour création de checkout, remboursement et traitement des webhooks.
- Montants exprimés en unités mineures entières (centimes), avec devise ISO-4217 ; jamais de nombres flottants.

## Authentification et compte

| Méthode | Route | Accès | Rôle |
|---|---|---|---|
| POST | `/auth/register` | Public | Créer un compte acheteur |
| POST | `/auth/login` | Public | Ouvrir une session sécurisée |
| POST | `/auth/logout` | Connecté | Fermer la session |
| POST | `/auth/password/forgot` | Public | Demander un lien de récupération |
| POST | `/auth/password/reset` | Jeton de récupération | Réinitialiser le mot de passe |
| POST | `/auth/email/verify` | Jeton de vérification | Vérifier l’adresse e-mail |
| POST | `/auth/phone/send-code` | Connecté | Demander un code SMS avec limitation de débit |
| POST | `/auth/phone/verify` | Connecté | Vérifier le téléphone |
| GET | `/me` | Connecté | Consulter son profil et ses rôles |
| PATCH | `/me` | Connecté | Modifier les champs autorisés du profil |

## Catalogue et favoris

| Méthode | Route | Accès |
|---|---|---|
| GET | `/categories` | Public |
| GET | `/products` | Public, produits approuvés uniquement |
| GET | `/products/{productId}` | Public, produit approuvé uniquement |
| GET | `/me/favorites` | Acheteur connecté |
| PUT | `/me/favorites/{productId}` | Acheteur connecté |
| DELETE | `/me/favorites/{productId}` | Acheteur connecté |

Les réponses publiques ne doivent jamais inclure les clés de stockage ou les URL de téléchargement des fichiers.

## Vendeur

| Méthode | Route | Accès |
|---|---|---|
| POST | `/seller/products` | Vendeur |
| PATCH | `/seller/products/{productId}` | Propriétaire vendeur, produit modifiable |
| POST | `/seller/products/{productId}/upload-intent` | Propriétaire vendeur |
| POST | `/seller/products/{productId}/submit-review` | Propriétaire vendeur |
| GET | `/seller/sales` | Vendeur, ses ventes uniquement |
| GET | `/seller/commissions` | Vendeur, ses commissions uniquement |
| GET | `/seller/payouts` | Vendeur, ses versements uniquement |
| POST | `/seller/payouts` | Vendeur, demande de versement |

La validation d’un fichier doit vérifier l’extension autorisée, le type réel, la taille et la sécurité du fichier. Ne pas faire confiance au nom ou au MIME fournis par le navigateur.

## Panier, commande et téléchargement

| Méthode | Route | Accès |
|---|---|---|
| GET | `/cart` | Acheteur connecté |
| POST | `/cart/items` | Acheteur connecté |
| PATCH | `/cart/items/{itemId}` | Acheteur propriétaire du panier |
| DELETE | `/cart/items/{itemId}` | Acheteur propriétaire du panier |
| POST | `/checkout` | Acheteur connecté, clé d’idempotence |
| GET | `/me/orders` | Acheteur, commandes personnelles |
| GET | `/me/orders/{orderId}` | Acheteur propriétaire ou admin autorisé |
| POST | `/me/orders/{orderId}/downloads/{productId}` | Acheteur ayant droit au téléchargement |

Le serveur relit le prix actuel et la disponibilité avant de créer la commande. Après paiement, l’accès est accordé uniquement si la commande est marquée payée à partir d’une confirmation vérifiée côté serveur. Les URL signées de téléchargement doivent expirer rapidement.

## Paiement, webhooks et administration

| Méthode | Route | Accès |
|---|---|---|
| POST | `/webhooks/stripe` | Stripe, signature vérifiée |
| POST | `/admin/products/{productId}/approve` | Admin |
| POST | `/admin/products/{productId}/reject` | Admin |
| GET | `/admin/orders` | Admin |
| POST | `/admin/orders/{orderId}/refunds` | Admin autorisé, idempotent |
| GET | `/admin/payouts` | Admin |
| POST | `/admin/payouts/{payoutId}/approve` | Admin autorisé |
| POST | `/admin/payouts/{payoutId}/mark-sent` | Admin autorisé, référence non sensible |
| GET | `/admin/users` | Admin, accès audité |

Ne jamais déclarer une commande payée à partir du retour navigateur. Vérifier la signature du webhook Stripe, enregistrer l’identifiant d’événement et ignorer proprement les événements déjà traités.

## Règles métier

- Un utilisateur peut être acheteur et vendeur ; les rôles sont cumulables.
- Un vendeur ne peut modifier que ses produits et lire que ses ventes/versements.
- Les produits en attente, rejetés ou archivés ne sont pas publiquement achetables.
- Le partage 50/50 de la phase 1 est enregistré avec chaque ligne de commande.
- La phase 2 (commission apporteur de 25 %) reste désactivée jusqu’à une décision produit/comptable et des tests dédiés.
- Aucun endpoint n’accepte ou ne retourne des secrets bancaires. L’intégration de versement doit utiliser Stripe Connect ou un prestataire conforme ; ne pas conserver d’IBAN brut dans les journaux ou dépôts.
