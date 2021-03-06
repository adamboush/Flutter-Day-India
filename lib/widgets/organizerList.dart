import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdaysindia/services/responsiveness.dart';
import 'package:flutterdaysindia/utils/app_info.dart';

import 'organizerhandle.dart';

class OrganizerList extends StatefulWidget {
  @override
  _OrganizerListState createState() => _OrganizerListState();
}

class _OrganizerListState extends State<OrganizerList> {
  var new_Data;
  List<Widget> widgets;
  Widget gap = SizedBox(
    width: 15.0,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String jsonData = await rootBundle.loadString(AppInfo.organizerjson);
      new_Data = json.decode(jsonData.toString());
      print(new_Data);
      widgets = List.generate(
          11,
          (index) => SizedBox(
                width: Responsiveness.isLargeScreen(context)
                    ? MediaQuery.of(context).size.width * 0.3
                    : MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        new_Data[index]["organizer_name"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsiveness.isSmallScreen(context)
                              ? 27.0
                              : 35.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: CircleLogo(new_Data[index]["logo"]),
                          backgroundColor: AppInfo.backgroundColor,
                          radius: Responsiveness.isSmallScreen(context)
                              ? 23.0
                              : 35.0,
                        ),
                        gap,
                        OrganizerMeetup(
                            string: new_Data[index]["meetup_handle"]),
                        gap,
                        OrganizerTwitter(
                          string: new_Data[index]["twitter_handle"],
                        ),
                      ],
                    ),
                  ],
                ),
              ));
//      await Future.delayed(Duration(seconds: 5));

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new_Data == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Wrap(
            spacing: 20,
            runSpacing: 20,
            runAlignment: WrapAlignment.center,
            children: widgets,
          );
  }
}

ImageProvider CircleLogo(String string) {
  String defaultLogoUrl =
      "https://miro.medium.com/max/1000/1*ilC2Aqp5sZd1wi0CopD1Hw.png";

  return CachedNetworkImageProvider(string ?? defaultLogoUrl);
}
