import 'product.dart';


class MyProduct {
  static List<Product> AllProducts = [
    Product(
        id: 1,
        name: 'MSI GeForce GTX 1050Ti',
        category: 'VideoCard',
        image: 'images/video_cards/1050Ti.png',
        description: 'Видеокарта GeForce GTX 1050 Ti, как следует из названия, создана специально для высокотребовательных игр, это настоящий маленький гигант в данном вопросе.',
        price: 95.0,
        quantity: 1,
    ),
    Product(
      id: 2,
      name: 'MSI GeForce RTX 2060',
      category: 'VideoCard',
      image: 'images/video_cards/2060Super.png',
      description: 'Видеокарта MSI GeForce RTX 2060 Super VENTUS GP OC [RTX 2060 SUPER VENTUS GP OC] – игровое устройство высокого уровня.',
      price: 320.0,
      quantity: 1,
    ),
    Product(
      id: 3,
      name: 'MSI GeForce RTX 3080',
      category: 'VideoCard',
      image: 'images/video_cards/3070Ti.png',
      description: 'Видеокарта Palit GeForce RTX 3080 GameRock (LHR) с оформлением кожуха в виде множества прозрачных кристаллов станет оригинальным дополнением мощного игрового компьютера. ',
      price: 535.0,
      quantity: 1,
    ),
    Product(
      id: 4,
      name: 'MSI GeForce RTX 4080',
      category: 'VideoCard',
      image: 'images/video_cards/4080.png',
      description: 'Видеокарта MSI GeForce RTX 4080 GAMING X TRIO – стильное и высокопроизводительное решение для игровых систем.',
      price: 1512.0,
      quantity: 1,
    ),
    Product(
      id: 5,
      name: 'Intel Core i5',
      category: 'CPU',
      image: 'images/cpu/i5.png',
      description: 'Процессор Intel Core i5-11400F OEM – это 6-ядерное/12-потоковое устройство для настольных компьютеров с архитектурой Intel Core 11-го поколения (Rocket Lake). ',
      price: 150.0,
      quantity: 1,
    ),
    Product(
      id: 6,
      name: 'Intel Core i7',
      category: 'CPU',
      image: 'images/cpu/i7.png',
      description: 'Процессор Intel Core i5-11700F OEM – отличный выбор для пользователей, желающих собрать игровой ПК или производительный универсальный компьютер. ',
      price: 193.0,
      quantity: 1,
    ),
    Product(
      id: 7,
      name: 'Intel Core i9',
      category: 'CPU',
      image: 'images/cpu/i9.png',
      description: '16-ядерный процессор Intel Core i9-12900K BOX рассчитан на комплектацию мощного игрового ПК или высокопроизводительной рабочей станции.',
      price: 514.0,
      quantity: 1,
    ),
  ];
}