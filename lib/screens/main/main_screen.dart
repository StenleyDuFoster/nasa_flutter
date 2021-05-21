import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nasa_app/constants/app_colors.dart';
import 'package:flutter_nasa_app/screens/main/main_bloc.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainBloc _block;

  @override
  void initState() {
    _block = MainBloc();
    _block.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: _block.items,
          initialData: NewInitState,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data is MainDataState) {
              return Container(
                margin: EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        snapshot.data?.apodEntity?.title ?? "",
                        style: TextStyle(color: AppColors.black),
                      ),
                    ),
                    Image.network(
                      snapshot.data?.apodEntity?.url ?? "",
                      height: MediaQuery.of(context).size.width - 40,
                      errorBuilder: (BuildContext context, Object widget, StackTrace? stacTrace) {
                        return Image.asset("images/nasa_logo.png", width: 100.0, height: 100.0);
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              snapshot.data?.apodEntity?.date ?? "",
                              style: TextStyle(color: AppColors.black),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                snapshot.data?.apodEntity?.mediaType ?? "",
                                style: TextStyle(color: AppColors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      snapshot.data?.apodEntity?.explanation ?? "",
                      style: TextStyle(color: AppColors.black),
                    ),
                  ],
                ),
              );
            } else if (snapshot.data is MainLoadingState) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(child: Image.asset("images/nasa_logo.png", width: 100.0, height: 100.0));
            }
          },
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(),
    );
  }
}
