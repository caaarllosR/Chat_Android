import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData       _icon;
  final String         _text;
  final PageController _pageController;
  final int            _page;

  DrawerTile(this._icon, this._text, this._pageController, this._page);

  Color getColor(context) {
    bool isSelected = _pageController.hasClients ? _pageController.page.round() == _page : _pageController.initialPage.round() == _page;
    return isSelected ? Theme.of(context).primaryColor : Colors.grey[700];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          if(_pageController.hasClients)
            _pageController.jumpToPage(_page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                _icon,
                size: 32.0,
                color: getColor(context),
              ),
              SizedBox(width: 32.0,),
              Text(
                _text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: getColor(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
