# PROJET JOBSHELP — SPÉCIFICATIONS OFFICIELLES

## Objectif

Créer une marketplace professionnelle de vente de fichiers numériques.

## A. Comptes

- Administrateur principal.
- Vendeurs.
- Acheteurs.
- Inscription et connexion sécurisées.
- Récupération de mot de passe.
- Adresse e-mail de secours.
- Vérification du téléphone.

## B. Catalogue

### Formats autorisés

- PDF
- ZIP
- EPUB
- MP4

### Catégories

- Documents professionnels.
- Tutoriels de fabrication.
- Guides et formations.
- Recettes et pâtisseries.
- Patrons de vêtements.
- Livres numériques.
- Modèles professionnels.

## C. Espace vendeur

- Importer ses fichiers.
- Fixer ses prix.
- Ajouter descriptions et images.
- Suivre ses ventes.
- Consulter ses commissions.
- Demander ses versements.

## D. Espace acheteur

- Consulter les produits.
- Ajouter plusieurs fichiers au panier.
- Effectuer un paiement unique.
- Télécharger les fichiers achetés.
- Consulter son historique.
- Enregistrer ses favoris.

## E. Espace administrateur

- Gérer tous les comptes.
- Valider les fichiers.
- Gérer les catégories.
- Contrôler les ventes.
- Consulter les paiements.
- Gérer les remboursements.
- Suivre les commissions.
- Gérer les versements.

## F. Paiements

Prévoir :

- Paiement par carte bancaire.
- Versements par virement bancaire IBAN.
- Intégration Stripe Connect.
- Environnement de test.
- Confirmation automatique des paiements.
- Historique des transactions.
- Gestion des remboursements.

## G. Commissions

### Première phase

- 50 % vendeur.
- 50 % JobsHelp.

### Deuxième phase

- Vente des fichiers de l’administrateur.
- 25 % de commission pour le client apporteur de vente.
- 75 % pour JobsHelp / administrateur avant frais.

## H. Sécurité

- Stockage privé.
- Téléchargements autorisés après paiement confirmé.
- Protection des comptes.
- Gestion des rôles.
- Protection des données personnelles.
- Aucun mot de passe ou secret bancaire dans le code public.

## I. Développement

- Construire progressivement les modules.
- Tester chaque fonctionnalité.
- Ne jamais activer les paiements réels avant validation complète.
- Conserver une sauvegarde du code et utiliser GitHub pour protéger le projet.
