import 'package:flutter/material.dart';

class RegisterSpecialityWidget extends StatefulWidget {
  const RegisterSpecialityWidget({required this.callback, super.key});

  final Function(String) callback;

  @override
  State<RegisterSpecialityWidget> createState() =>
      _RegisterSpecialityWidgetState();
}

class _RegisterSpecialityWidgetState extends State<RegisterSpecialityWidget> {
  final String _title = 'SSTC';
  List multipleSelected = [];
  List checkListItems = [
    {
      "id": 0,
      "value": false,
      "title": "Slit-lamp Biomicroscopy (incl. 90 D)",
    },
    {
      "id": 1,
      "value": false,
      "title": "Indirect ophthalmoscopy",
    },
    {
      "id": 2,
      "value": false,
      "title": "Retinoscopy",
    },
    {
      "id": 3,
      "value": false,
      "title": "Squint & Othoptics",
    },
    {
      "id": 4,
      "value": false,
      "title": "Contact Lens Basic: RGP Fitting",
    },
    {
      "id": 5,
      "value": false,
      "title": "Contact Lens Basic: Soft Contact Lens fitting",
    },
    {
      "id": 6,
      "value": false,
      "title": "Contact Lens Advanced ROSE-K Contact Lens Fitting (1 hour)",
    },
    {
      "id": 7,
      "value": false,
      "title": "Perimetry",
    },
    {
      "id": 8,
      "value": false,
      "title": "RNFL OCT",
    },
    {
      "id": 9,
      "value": false,
      "title": "UBM",
    },
    {
      "id": 10,
      "value": false,
      "title": "FFA",
    },
    {
      "id": 11,
      "value": false,
      "title": "Specular Microscopy",
    },
    {
      "id": 12,
      "value": false,
      "title": "ERG, VEP EOG interpretations",
    },
    {
      "id": 13,
      "value": false,
      "title": "Corneal Topography",
    },
    {
      "id": 14,
      "value": false,
      "title": "Low Vision Aids",
    },
    {
      "id": 15,
      "value": false,
      "title": "Biometry",
    },
    {
      "id": 16,
      "value": false,
      "title": "Gonioscopy/Tonometry (NCT & Applanation)",
    },
    {
      "id": 17,
      "value": false,
      "title": "Green Laser",
    },
    {
      "id": 18,
      "value": false,
      "title": "Myopia progression Control",
    },
    {
      "id": 19,
      "value": false,
      "title": "USG: A & B Scan",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: checkListItems
            .map((item) => CheckboxListTile(
                  dense: true,
                  title: Text(item['title']),
                  value: item['value'],
                  onChanged: (val) {
                    setState(() {
                      item['value'] = val;
                      if (val == true) {
                        multipleSelected.add(item['title']);
                      } else {
                        multipleSelected.remove(item['title']);
                      }
                      print(multipleSelected);
                      widget.callback(multipleSelected.join(", "));
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
