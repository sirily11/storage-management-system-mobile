import 'package:flutter/material.dart';

class ButtonInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Function onClick;

  ButtonInfo(
      {@required this.label,
      @required this.icon,
      @required this.color,
      @required this.value,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      child: InkWell(
        onTap: () {
          if (this.onClick != null) {
            this.onClick();
          }
        },
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                icon,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8.0,
                    )
                  ]),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              label,
            ),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
