List _items = [];

Future<void> readJson() async {
  final String response = await rootBundle.loadString('assets/products.json');
  final data = await jsonDecode(response);
  setState(() {
    _items = data['items'];
    print('..number of item ${_items.length}');
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: const Text(
        'Products',
        style: TextStyle(
          color: Colors.white38,
          fontSize: 27,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    body: Column(
      children: [
        _items.isNotEmpty?Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(10),
                color: Colors.amber,
                child: ListTile(
                  title: Text(_items[index]["name"]),
                  subtitle: Text(_items[index]["description"]),
                ),
              );
            },
          ),
        ): ElevatedButton(
          onPressed: () {
            readJson();
          },
          child: const Center(child: Text("loaf")),
        )
      ],
    ),
  );
}