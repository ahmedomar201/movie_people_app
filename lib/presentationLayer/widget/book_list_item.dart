import 'package:flutter/material.dart';

class PersonListItem extends StatelessWidget {
  final String title;
  final String? imageUrl;

  const PersonListItem({
    super.key,
    required this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, size: 50),
              )
            : const Icon(Icons.person, size: 50),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      // subtitle: Text(
      //   role,
      //   style: const TextStyle(color: Colors.grey),
      // ),
    );
  }
}
