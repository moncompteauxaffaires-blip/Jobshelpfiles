# Sécurité et plan de tests

## Sécurité minimale

### Comptes et autorisations

- Utiliser un fournisseur d’authentification maintenu ou une implémentation reconnue ; ne jamais écrire soi-même un mécanisme cryptographique.
- Stocker uniquement un hash de mot de passe robuste (Argon2id ou bcrypt configuré correctement) si l’authentification est gérée par l’application.
- Cookies de session `HttpOnly`, `Secure`, `SameSite` approprié ; renouvellement et révocation des sessions.
- Appliquer le contrôle d’accès côté serveur sur chaque ressource, y compris les routes admin.
- Activer MFA pour les administrateurs avant production.
- Limiter les tentatives de connexion, récupération de mot de passe et vérification SMS ; ne pas révéler si une adresse existe.

### Fichiers

- Stockage privé sans accès anonyme ; identifiants de stockage non prédictibles.
- Autoriser uniquement PDF, ZIP, EPUB et MP4 après validation du contenu réel, taille et signature de fichier.
- Renommer les objets, neutraliser les noms d’origine, analyser antivirus et isoler les fichiers en attente.
- Servir par URL signée de courte durée après vérification d’une commande payée et du droit d’accès.
- Empêcher les archives ZIP path traversal et les fichiers excessifs/archives bombes.

### Paiements et données

- Mode test par défaut ; aucun paiement réel avant checklist signée et validation de l’exploitant.
- Les clés Stripe sont injectées via gestionnaire de secrets, jamais enregistrées dans Git, logs ou client.
- Vérifier la signature des webhooks sur le corps brut et traiter les événements de façon idempotente.
- Ne pas stocker de données de carte. Utiliser Stripe/PSP pour les opérations de paiement.
- Ne pas stocker d’IBAN brut dans l’application si un identifiant de compte connecté suffit ; ne jamais commiter de données bancaires.
- Chiffrer les communications, limiter l’accès aux données personnelles, définir durée de conservation et procédure de suppression/export.

## Plan de tests

### Unitaires

- Calcul de prix, arrondis en centimes et partage des commissions.
- Transitions de statut produit, commande, paiement, remboursement et versement.
- Validation formats, tailles, devise et entrées utilisateur.

### Intégration

- Chaque route vérifie authentification, rôle et propriété des ressources.
- Produit non approuvé impossible à acheter ou télécharger.
- Commande non payée impossible à télécharger.
- Webhooks invalides rejetés ; événement répété sans effet secondaire dupliqué.
- Remboursement plafonné au montant payé et idempotent.
- Une modification de prix après achat ne change pas la commande existante.

### E2E

1. Acheteur s’inscrit, consulte le catalogue et achète en mode test.
2. Après confirmation serveur, l’acheteur télécharge le fichier autorisé.
3. Vendeur crée un produit, l’admin le valide et le vendeur consulte ses ventes.
4. Un utilisateur tente d’accéder aux ventes, commandes ou fichiers d’un autre compte : accès refusé.
5. Admin rembourse une commande test et l’historique reflète correctement le statut.

## Checklist avant paiements réels

- [ ] Revue de sécurité et test d’intrusion autorisé réalisés.
- [ ] Stripe Connect et vérification vendeur configurés selon les exigences du prestataire.
- [ ] Webhooks en HTTPS, signature et idempotence testées.
- [ ] Politique de remboursement, litiges, conditions de vente et confidentialité validées.
- [ ] Règles fiscales/comptables, commission et facturation validées pour les pays servis.
- [ ] Sauvegarde/restauration testée et accès admin protégés par MFA.
- [ ] Alertes, gestion d’incident, support client et rapprochement financier opérationnels.
- [ ] Approbation explicite du propriétaire pour passer le mode de paiement en production.

Tant qu’une case n’est pas validée, les paiements réels et les versements automatiques restent désactivés.
