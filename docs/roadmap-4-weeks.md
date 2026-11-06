# Plan JobsHelp en 4 semaines

Ce plan vise un MVP testable. Il ne signifie pas que les paiements ou la plateforme seront prêts pour la production à la fin du calendrier ; la mise en production dépend des tests, de la conformité et de la validation humaine.

## Semaine 1 — socle

- Confirmer la stack, les règles de commission et les devises prises en charge.
- Initialiser Next.js + TypeScript, lint, formatage et pipeline CI.
- Créer PostgreSQL, migrations et données de démonstration.
- Authentification, vérification e-mail, récupération de mot de passe.
- Rôles cumulables et contrôles d’accès serveur.
- Pages de base : accueil, connexion, inscription, tableau de bord.

**Critères de sortie :** utilisateurs et rôles testés ; aucun secret dans le dépôt ; migrations exécutables sur une base vierge.

## Semaine 2 — catalogue et vendeurs

- Catégories et catalogue public.
- Création/édition d’un produit et états draft/pending/approved/rejected.
- Téléversement vers un stockage privé avec limite de taille.
- Contrôles de type réel, format permis et analyse antivirus.
- Modération admin et journalisation.
- Favoris et dashboard vendeur initial.

**Critères de sortie :** les produits en attente ne sont pas visibles publiquement ; le propriétaire seul peut modifier son produit ; aucun fichier n’est servi publiquement.

## Semaine 3 — commandes et paiements test

- Panier multi-produits et prix autoritatifs côté serveur.
- Commande et lignes avec instantanés de prix et commission.
- Stripe Checkout en environnement test uniquement.
- Webhook vérifié, idempotence et rapprochement commande/paiement.
- Historique acheteur et tests d’échec, doublon webhook et panier modifié.

**Critères de sortie :** aucune confirmation basée uniquement sur le navigateur ; répétition du webhook ne crée ni double commande ni double versement.

## Semaine 4 — accès, commissions, admin et validation

- Téléchargement contrôlé après paiement confirmé, URL signée expirante.
- Commission de phase 1 et vues vendeur.
- Demande de versement, sans transfert réel pendant le MVP.
- Interface admin pour comptes, modération, remboursements et paiements.
- Tests e2e des parcours acheteur, vendeur et admin.
- Revue sécurité, sauvegarde/restauration, logs et procédure d’incident.

**Critères de sortie :** critères de sécurité et tests de `security-and-tests.md` passent ; revue fonctionnelle validée ; paiement réel désactivé par défaut.

## Après le MVP

- Vérification juridique, fiscale et conformité du modèle marketplace.
- Stripe Connect réel et vérification des comptes vendeurs.
- Phase 2 de commission d’apporteur après définition des règles, litiges et remboursements.
- Monitoring, support, politiques de conservation et déploiement progressif.
