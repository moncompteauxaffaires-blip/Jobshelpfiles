# Structure technique proposée

## Choix de départ

MVP web en TypeScript avec Next.js App Router, PostgreSQL, Stripe en mode test et un stockage objet privé compatible S3. Les composants métier doivent rester séparés de l’interface afin de pouvoir extraire l’API plus tard.

## Arborescence cible

```text
jobshelp/
├── app/
│   ├── (public)/                 # accueil, catalogue, pages produit
│   ├── (auth)/                   # inscription, connexion, récupération
│   ├── buyer/                    # commandes, favoris, téléchargements
│   ├── seller/                   # produits, ventes, commissions, versements
│   ├── admin/                    # modération, comptes, commandes, remboursements
│   └── api/v1/                   # handlers HTTP versionnés
├── components/                   # composants UI partagés
├── features/
│   ├── auth/
│   ├── catalog/
│   ├── cart/
│   ├── orders/
│   ├── payments/
│   ├── downloads/
│   ├── commissions/
│   └── payouts/
├── lib/
│   ├── auth/                     # session et autorisations
│   ├── db/                       # client PostgreSQL et requêtes
│   ├── storage/                  # stockage privé
│   ├── payments/                 # adaptateur Stripe
│   ├── validation/               # schémas de validation
│   └── security/
├── db/
│   └── migrations/
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── docs/
├── .env.example                 # noms des variables seulement, aucune valeur secrète
├── .gitignore
├── package.json
└── README.md
```

## Règles d’implémentation

- Les routes API appellent des services métier ; la logique de paiement ne vit pas dans les composants UI.
- Toute entrée est validée côté serveur avec des schémas stricts.
- Les IDs d’utilisateur, rôle et prix proviennent de données serveur fiables, jamais du navigateur.
- Le prix et la commission sont copiés dans la ligne de commande au moment de l’achat : une modification ultérieure du produit ne change pas une ancienne commande.
- Les fichiers sont adressés par une clé de stockage interne, pas par une URL publique.
- Chaque changement de statut important est auditable.
- Les migrations SQL sont versionnées et testées sur une base de test avant application.

## Variables de configuration à prévoir

Voir `.env.example` lorsqu’il sera ajouté à l’application. Les valeurs réelles doivent être fournies par le gestionnaire de secrets de l’environnement, jamais commitées dans le dépôt. Stripe doit rester en mode test jusqu’à validation de la checklist de production.
