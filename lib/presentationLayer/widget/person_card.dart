import 'package:flutter/material.dart';
import 'package:movie_people_app/presentationLayer/widget/person_details.dart'
    show PersonDetails;

import '../../dataLayer/networks/models/person_model.dart';
import 'image_person_screen.dart';

class PersonCard extends StatelessWidget {
  final String name;
  final String department;
  final String imageUrl;
  final PersonModel person;

  const PersonCard({
    super.key,
    required this.name,
    required this.department,
    required this.imageUrl,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FullImageScreen(imageUrl: imageUrl, person: person),
                      ),
                    );
                  },
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => PersonDetails(person: person),
                          );
                        },

                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    department,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
