import 'package:flutter/material.dart';
import '../../dataLayer/networks/models/person_model.dart';
import 'image_person_screen.dart';

class PersonDetails extends StatelessWidget {
  final PersonModel person;

  const PersonDetails({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullImageScreen(
                            imageUrl: person.profilePath != null
                                ? 'https://image.tmdb.org/t/p/w500${person.profilePath}'
                                : 'https://via.placeholder.com/150',
                            person: person,
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                      person.profilePath != null
                          ? 'https://image.tmdb.org/t/p/w500${person.profilePath}'
                          : 'https://via.placeholder.com/150',

                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (person.originalName != null &&
                      person.originalName != person.name)
                    Text(
                      'Original name: ${person.originalName}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  const SizedBox(height: 16),
                  infoPerson(
                    icon: Icons.work,
                    label: 'Department',
                    value: person.knownForDepartment ?? 'Not specified',
                  ),
                  const SizedBox(height: 8),
                  infoPerson(
                    icon: Icons.star,
                    label: 'Popularity',
                    value: person.popularity?.toStringAsFixed(1) ?? 'N/A',
                  ),
                  const SizedBox(height: 8),
                  infoPerson(
                    icon: Icons.person,
                    label: 'Gender',
                    value: getGenderString(person.gender),
                  ),
                  if (person.knownFor != null &&
                      person.knownFor!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Known For:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...person.knownFor!.map(
                      (work) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.movie,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                work.title ?? work.name ?? 'Unnamed Project',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getGenderString(int? gender) {
    switch (gender) {
      case 1:
        return 'Female';
      case 2:
        return 'Male';
      case 3:
        return 'Non-binary';
      default:
        return 'Not specified';
    }
  }

  Widget infoPerson({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
