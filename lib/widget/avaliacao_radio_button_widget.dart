import 'package:flutter/material.dart';





class AvaliacaoRadioButtonWidget extends StatefulWidget {
  final String questao;
  const AvaliacaoRadioButtonWidget({Key? key, required this.questao}) : super(key: key);

  @override
  _AvaliacaoRadioButtonWidgetState createState() => _AvaliacaoRadioButtonWidgetState();
}

class _AvaliacaoRadioButtonWidgetState extends State<AvaliacaoRadioButtonWidget> {
  // The group value
  var _result;
  Widget build(BuildContext context) {
    return  Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
      Expanded(
      flex: 1,
      child:Text(widget.questao)),
              Expanded(
              flex: 1,
              child: RadioListTile(
                  title: const Text('1'),
                  value: 1,
                  groupValue: _result,
                  onChanged: (value) {
                    setState(() {
                      _result = value;
                    });
                  })),

              Expanded(
    flex: 1, child: RadioListTile(
                  title: const Text('2'),
                  contentPadding: EdgeInsets.all(5),
                  value: 2,
                  groupValue: _result,
                  onChanged: (value) {
                    setState(() {
                      _result = value;
                    });
                  })),
              /*   RadioListTile(
                  title: const Text('3'),
                  value: 3,
                  groupValue: _result,
                  onChanged: (value) {
                    setState(() {
                      _result = value;
                    });
                  }),
              RadioListTile(
                  title: const Text('4'),
                  value: 4,
                  groupValue: _result,
                  onChanged: (value) {
                    setState(() {
                      _result = value;
                    });
                  }),
              RadioListTile(
                  title: const Text('5'),
                  value: 5,
                  groupValue: _result,
                  onChanged: (value) {
                    setState(() {
                      _result = value;
                    });
                  }),*/

              //Text(_result == 7 ? 'Correct!' : 'Please chose the right answer!')
            ],
          );
  }
}