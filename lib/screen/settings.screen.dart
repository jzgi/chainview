import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/my_colors.dart';
import '../data/share_pref.dart';
import '../provider/global_notifier.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  String _baseUrl = "";
  bool _searchEnable = false;
  bool _navbarEnable = false;
  late TextEditingController _urlController;
  late FocusNode _okBtnFocusNode;
  late FocusNode _urlFocusNode;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _okBtnFocusNode = FocusNode();
    _urlFocusNode = FocusNode();
    _loadData();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _okBtnFocusNode.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                _showEditDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("启动加载页面",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    color: MyColors.grey_90,
                                    fontWeight: FontWeight.bold)),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              _showEditDialog(context);
                            },
                            child: Text("修改",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: MyColors.primary))),
                        SizedBox(height: 50)
                      ],
                    ),
                    Text(_baseUrl.isNotEmpty ? _baseUrl : "暂未设置",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[400])),
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {
                _changeSearchState(!_searchEnable);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("搜索栏",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    color: MyColors.grey_90,
                                    fontWeight: FontWeight.bold)),
                        Spacer(),
                        Switch(
                          value: _searchEnable,
                          onChanged: _changeSearchState,
                          activeColor: MyColors.primary,
                          inactiveThumbColor: Colors.grey,
                        )
                      ],
                    ),
                    Text("是否显示搜索栏",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[400])),
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {
                _changeNavbarState(!_navbarEnable);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("导航栏",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    color: MyColors.grey_90,
                                    fontWeight: FontWeight.bold)),
                        Spacer(),
                        Switch(
                          value: _navbarEnable,
                          onChanged: _changeNavbarState,
                          activeColor: MyColors.primary,
                          inactiveThumbColor: Colors.grey,
                        )
                      ],
                    ),
                    Text("是否显示导航栏",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[400])),
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {
                _showConfirmDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("浏览器缓存",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    color: MyColors.grey_90,
                                    fontWeight: FontWeight.bold)),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              _showConfirmDialog(context);
                            },
                            child: Text("清理",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: MyColors.primary))),
                        SizedBox(height: 50)
                      ],
                    ),
                    Text("清理浏览器缓存内容：页面、图片、Cookie等",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[400])),
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Version",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                  color: MyColors.grey_90,
                                  fontWeight: FontWeight.bold)),
                      SizedBox(height: 50)
                    ],
                  ),
                  Text("1.0.4",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[400])),
                ],
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushNamed(context, "/");
          },
        ),
        title: Text("品链浏览器设置"),
      ),
    );
  }

  Future<void> _loadData() async {
    _baseUrl = (await SharedPref.getBaseUrl()) ?? _baseUrl;
    _searchEnable = (await SharedPref.getSearchEnable()) ?? _searchEnable;
    _navbarEnable = (await SharedPref.getNavbarEnable()) ?? _navbarEnable;
    _urlController.text = _baseUrl;
    setState(() {});
  }

  void _changeBaseUrl(String baseUrl) {
    setState(() {
      _baseUrl = baseUrl;
    });
    SharedPref.setBaseUrl(baseUrl);
  }

  void _changeSearchState(bool value) {
    setState(() {
      _searchEnable = value;
    });
    SharedPref.setSearchEnable(value);
  }

  void _changeNavbarState(bool value) {
    setState(() {
      _navbarEnable = value;
    });
    SharedPref.setNavbarEnable(value);
  }

  Future<void> _showEditDialog(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) {
              if (event is RawKeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  _urlFocusNode.unfocus();
                  _okBtnFocusNode.requestFocus();
                }
              }
            },
            child: AlertDialog(
              title: const Text('输入URL'),
              content: TextField(
                autofocus: true,
                keyboardType: TextInputType.url,
                controller: _urlController,
                focusNode: _urlFocusNode,
                onSubmitted: (value) {
                  print(value);
                  _changeBaseUrl(_urlController.text);
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                    focusNode: _okBtnFocusNode,
                    onPressed: () {
                      _changeBaseUrl(_urlController.text);
                      Navigator.pop(context);
                    },
                    child: const Text('确认')),
              ],
            ));
      },
    );
  }

  Future<void> _showConfirmDialog(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认清除浏览器缓存？'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
                autofocus: true,
                onPressed: () {
                  context.read<GlobalNotifier>().flagClearCache();
                  Navigator.pop(context);
                },
                child: const Text('确认')),
          ],
        );
      },
    );
  }
}
