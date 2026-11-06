# Jobshelp files

Marketplace professionnelle de vente de fichiers numériques.

## Liens existants

- Version web : https://d3a30ca3-be48-44eb-85ac-1b823f401a5d-00-2ej8kz4e12sto.archer.replit.dev/jobshelp-web/?nativeBrowserPresentationStyle=fullScreen
- Version mobile : https://d3a30ca3-be48-44eb-85ac-1b823f401a5d-00-2ej8kz4e12sto.expo.archer.replit.dev/?nativeBrowserPresentationStyle=fullScreen

## Cahier des charges

- [Spécifications officielles](SPECIFICATIONS-JOBSHELP.md)
- [Architecture](docs/architecture.md)
- [Structure technique proposée](docs/project-structure.md)
- [API V1](docs/api-v1.md)
- [Schéma PostgreSQL V1](docs/database-schema-v1.sql)
- [Plan de développement sur 4 semaines](docs/roadmap-4-weeks.md)
- [Sécurité et plan de tests](docs/security-and-tests.md)
- [Roadmap détaillée](docs/roadmap.md)
- [Modèle de données descriptif](docs/database.md)

## Stack de référence proposée

- Web : Next.js (App Router) avec TypeScript
- API : Route Handlers Next.js pour le MVP, isolables ensuite en service dédié
- Base de données : PostgreSQL
- Paiement : Stripe Checkout et Stripe Connect, d’abord en mode test
- Fichiers : stockage objet privé compatible S3 avec liens temporaires
- Tests : Vitest, tests d’intégration API et Playwright pour les parcours critiques

Cette stack est une proposition de départ à valider avant le développement. Le dépôt contient le cahier des charges et les documents de conception ; ces fichiers ne constituent pas encore une application complète prête à déployer.

## Principes non négociables

- Aucun paiement réel avant validation complète et accord explicite de mise en production.
- Aucun secret, mot de passe, clé privée ou donnée bancaire sensible dans Git.
- Fichiers numériques en stockage privé ; téléchargement seulement après confirmation serveur du paiement.
- Les événements de paiement sont vérifiés par signature et traités de manière idempotente.
- Les règles de commissions sont versionnées et enregistrées sur chaque commande.
