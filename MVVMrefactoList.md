# Liste de la refactorisation de l'application

## Séparation logique métier et interface

[UserListView](UserList/Sources/UserListView.swift)  
[ ] Dans **UserListView**, on retrouve 4 propriétés qui devraient être dans un ou plusieurs **viewModel** :

```swift
    @State private var users: [User] = []
    @State private var isLoading = false
    
    private let repository = UserListRepository()
    
    // Logique liée à la toolbar
    @State private var isGridView = false
```

[ ] Dans la **NavigationView**, nous retrouvons un `onAppear` qui pourrait être déplacé dans un **viewModel** car il contient de la logique.

[ ] reloadUser n'a rien à faire dans notre classe UI. Cette logique doit être gérée par le viewModel

[ ] De même pour les méthodes fetchUsers, shouldLoadMoreData et reloadUsers, qui n'ont pas leur place ici

## Amélioration de la séparation des préoccupations (SoC)

[UserListView](UserList/Sources/UserListView.swift)

[ ] Dans la **NavigationView**, nous pouvons séparer la liste et les rows de la liste pour clarifier le code.

[ ] **UserListView** devrait prendre une liste d'utilisateurs en paramètre lors de son initialisation, et chaque ligne de la liste devrait prendre un utilisateur ou du moins un objet ou autres.

[ ] Ensuite, pour la **List**, chaque row doit être un élément UI, et pour la **ScrollView**, chaque contact doit avoir sa propre classe UI.

[UserDetailView](UserList/Sources/UserDetailView.swift)  

[ ] L'image de représentation d'un contact est utilisé ici mais aussi dans notre view UserList il serait interéssant de la décaler dans une view a part avec deux propriété width et heiht a mettre dans l'init

## Forte dépendance entre les fichiers

[ ] Nos vues de liste et de détail dépendent trop de l'utilisateur. Il faudrait les rendre plus indépendantes afin de pouvoir les réutiliser avec d'autres objets.
