class OnBoardModel{
  String image;
  String text;
  String description;
  
  OnBoardModel({
    required this.image,
    required this.text,
    required this.description,
  });
}

List<OnBoardModel> screens = <OnBoardModel>[
  OnBoardModel(image: 'assets/images/SaveMoney.png', text: 'Économiser de largent', description: 'Contrôlez votre argent en un seul \nendroit'),
  OnBoardModel(image: 'assets/images/CheckWallet.png', text: 'Vérifiez votre portefeuille', description: 'Dans notre application, vous pouvez suivre \nvos dépenses et vos revenus')
];