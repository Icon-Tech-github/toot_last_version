class Product {
  Product({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? meals;
  int kacl;

  static List<Product> tabIconsList = <Product>[
    Product(
      imagePath: 'assets/fitness_app/pngegg (5).png',
      titleTxt: 'Orange',
      kacl: 525,
      meals: <String>['Bread,', 'Peanut butter,', 'Apple'],
      startColor: '#FFC400',
      endColor: '#FFB295',
    ),
    Product(
      imagePath: 'assets/fitness_app/pngegg (7).png',
      titleTxt: 'Watermelon',
      kacl: 602,
      meals: <String>['Salmon,', 'Mixed veggies,', 'Avocado'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    Product(
      imagePath: 'assets/fitness_app/pngegg (8).png',
      titleTxt: 'Lemon',
      kacl: 0,
      meals: <String>['Recommend:', '800 kcal'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Product(
      imagePath: 'assets/fitness_app/pngegg (6).png',
      titleTxt: 'Strawberry',
      kacl: 0,
      meals: <String>['Recommend:', '703 kcal'],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
    Product(
      imagePath: 'assets/fitness_app/pngegg (4).png',
      titleTxt: 'Mango',
      kacl: 525,
      meals: <String>['Bread,', 'Peanut butter,', 'Apple'],
      startColor: '#FFC400',
      endColor: '#FFB295',
    ),
  ];
}
