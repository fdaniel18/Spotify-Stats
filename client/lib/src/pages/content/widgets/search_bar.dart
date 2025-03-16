import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final double height;

  const CustomSearchBar({
    super.key,
    required this.onSearch,
    this.height = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Container(
      height: height,
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Container(
          height: height * 0.75,
          width: MediaQuery.of(context).size.width * 0.60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  onSearch(controller.text);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(Icons.search, color: Colors.grey[600]),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'What do you want to search?',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: height * 0.25),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  onSubmitted: (String value) {
                    onSearch(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}