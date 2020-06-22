import 'package:flutter/material.dart';

class InshortUIPage extends StatefulWidget {
  final double screenHeight;
  final List cardData;
  final currentIndex;

  @override
  _InshortUIPageState createState() => _InshortUIPageState();
  InshortUIPage(
      {Key key,
      @required this.screenHeight,
      @required this.cardData,
      this.currentIndex = 0})
      : super(key: key);
}

class _InshortUIPageState extends State<InshortUIPage>
    with TickerProviderStateMixin {
  AnimationController _forwardAnimationController;
  AnimationController _previousAnimationController;
  

  double minCardPosition = 0;
  double maxCardPosition = 0;
  List cardData;
  int currentIndex = 0;
  List<Widget> displayCard = []; // to Store new build Card.

  @override
  void initState() {
    // print(widget.screenHeight); // we get the current display size...
    cardData = widget.cardData;
    currentIndex = widget.currentIndex;
    maxCardPosition = widget.screenHeight;
    _forwardAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 550));
    _previousAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 550));

    _forwardAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //Make Change in Update....
        _forwardAnimationController.reset();
        _indexUpdater(1);
      }
    });
    _previousAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //Make Change in Update....
        _previousAnimationController.reset();
        _indexUpdater(-1);
      }
    });

    super.initState();
  }

  _indexUpdater(int index) {
    if (currentIndex + index < cardData.length && currentIndex + index > -1) {
      setState(() {
        currentIndex = currentIndex + index;
      });
    } else {
      print(
          'You are going out of index, Your Current index is : $currentIndex');
    }
  }

  @override
  void dispose() {
    _forwardAnimationController.dispose();
    _previousAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragUpdate: _verticalDragUpdate,
        onVerticalDragEnd: _verticalDragEnd,
        child: Stack(
          children: _buildCardCurrent(cardData, currentIndex),
        ));
  }

  // Custom Card Building....
  _buildCardCurrent(List cardData, int currentIndex) {
    displayCard = [];
    int cardDataLength = cardData.length;

    // making of next Card
    if (currentIndex < cardDataLength - 1) {
      displayCard.add(Positioned(
          child: cardDesign(cardData[currentIndex + 1]['photo'],
              cardData[currentIndex + 1]['body']) //Update...
          ));
    } else {
      displayCard.add(Container(
        alignment: Alignment.center,
        child: Text('End of Card...'),
      ));
    }

    displayCard.add(InshortColorCard(
        cardDesign: cardDesign(
            cardData[currentIndex]['photo'], cardData[currentIndex]['body']),
        controller: _forwardAnimationController,
        minCardPosition: 0,
        maxCardPosition: -maxCardPosition));

    if (currentIndex > 0) {
      displayCard.add(InshortColorCard(
          cardDesign: cardDesign(cardData[currentIndex - 1]['photo'],
              cardData[currentIndex - 1]['body']),
          controller: _previousAnimationController,
          minCardPosition: -maxCardPosition,
          maxCardPosition: 0));
    }
    return displayCard;
  }

  _verticalDragUpdate(DragUpdateDetails updateDetails) {
    // This function is to handle the vertical Drag....
    // print(_animationController.value);
    double fractionDragged = updateDetails.primaryDelta / widget.screenHeight;
    // _animationController.value = _animationController.value - fractionDragged;
    if (_forwardAnimationController.value > 0) {
      _forwardAnimationController.value =
          _forwardAnimationController.value - fractionDragged;
    } else if (_previousAnimationController.value > 0) {
      _previousAnimationController.value =
          _previousAnimationController.value + fractionDragged;
    } else if (fractionDragged < 0) {
      _forwardAnimationController.value =
          _forwardAnimationController.value - fractionDragged;
    } else if (fractionDragged > 0) {
      _previousAnimationController.value =
          _previousAnimationController.value + fractionDragged;
    }
  }

  _verticalDragEnd(DragEndDetails endDetails) {
    // After Completing Drag....
    if (_forwardAnimationController.value >= 0.30) {
      _forwardAnimationController.fling(velocity: 1);
    } else {
      _forwardAnimationController.fling(velocity: -1);
    }
    if (_previousAnimationController.value >= 0.30) {
      _previousAnimationController.fling(velocity: 1);
    } else {
      _previousAnimationController.fling(velocity: -1);
    }
  }

  //Post Card Design....
  Widget cardDesign(
    String imageUrl,
    String bodyData,
  ) {
    return Card(
      child: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: Text(
                    imageUrl,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.98,
                  color: Colors.white,
                  child: Text(bodyData),
                ),
              )
            ],
          )),
    );
  }
}

class InshortColorCard extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> positionAnimation;
  final double minCardPosition;
  final double maxCardPosition;
  final Widget cardDesign;

  InshortColorCard(
      {this.controller,
      this.minCardPosition,
      this.maxCardPosition,
      this.cardDesign})
      : positionAnimation =
            Tween<double>(begin: minCardPosition, end: maxCardPosition)
                .animate(controller);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return Positioned(
            top: positionAnimation.value,
            child: cardDesign,
          );
        });
  }
}

