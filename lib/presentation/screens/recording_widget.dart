import 'dart:io';

import 'package:attendance/presentation/utils/colors.dart';
import 'package:attendance/presentation/utils/constants.dart';
import 'package:attendance/presentation/utils/utility.dart';
import 'package:attendance/presentation/widgets/loading.dart';
import 'package:attendance_shared/attendance_shared.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class RecordingWidget extends StatefulWidget {
  final AttendanceUser user;
  const RecordingWidget({Key key, this.user}) : super(key: key);

  @override
  _RecordingWidgetState createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> {
  int _start = 3;
  int _current = 3;
  CameraController controller;
  String videoPath;
  bool _timerVisibilty = false;
  bool _isRecording = false;

  List<CameraDescription> cameras;
  int selectedCameraIdx;

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void resetStats() {
    setState(() {
      _start = 3;
      _current = 3;
      _timerVisibilty = false;
      _isRecording = false;
      controller.initialize();
    });
  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      setState(() {
        _timerVisibilty = false;
      });
      if (controller != null &&
          controller.value.isInitialized &&
          !controller.value.isRecordingVideo) {
        _onRecordButtonPressed();
        setState(() {
          _isRecording = true;
        });
        Future.delayed(Duration(seconds: 5), () {
          if (controller != null &&
              controller.value.isInitialized &&
              controller.value.isRecordingVideo) {
            _onStopButtonPressed();
            setState(() {
              _isRecording = false;
            });
            resetStats();
          }
        });
      }

      print("Done");
      sub.cancel();
    });
  }

  Future uploadToStorage() async {
    try {
      final DateTime now = DateTime.now();

      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String videoDirectory = '${appDirectory.path}/Videos';
      await Directory(videoDirectory).create(recursive: true);
      final String currentTime = now.millisecondsSinceEpoch.toString();
      final String fileLocalPath = '$videoDirectory/$currentTime.mp4';

      final String storageId =
          (currentTime.toString() + widget.user.uId.toString());

      // PickedFile video = await _picker.getVideo(
      //   source: ImageSource.camera,
      //   maxDuration: Duration(seconds: 5),
      // );

      // print("Url = $url");
      // return url;
    } catch (error) {
      print(error);
      return showToastMessage("Upload task error", Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 1;
        });
        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.medium);
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      showToastMessage("${e.description}", Colors.red);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Loading();
    }
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  void _onRecordButtonPressed() {
    _startVideoRecording();
  }

  void _onStopButtonPressed() {
    _stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      //showToastMessage('Video recorded to $videoPath', Colors.grey);
    });
  }

  Future _startVideoRecording() async {
    if (!controller.value.isInitialized) {
      //showToastMessage("Please wait", Colors.grey);
      return null;
    }

    if (controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.startVideoRecording();
    } on CameraException catch (e) {
      showToastMessage("${e.description}", Colors.red);
      return null;
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording().then((value) async {
        setState(() {
          videoPath = value.path;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogPreview(
                path: videoPath,
                user: widget.user,
              );
            });
      });
    } on CameraException catch (e) {
      showToastMessage("${e.description}", Colors.red);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                child: Padding(
                  padding: kPadding10,
                  child: ClipRRect(
                      borderRadius: kBorderR20, child: _cameraPreviewWidget()),
                ),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.8),
                  borderRadius: kBorderR20,
                ),
              ),
              if (_timerVisibilty)
                Center(
                  child: Container(
                    height: 150.h,
                    width: 150.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white30,
                    ),
                    padding: kPadding20,
                    child: Center(
                      child: Text(
                        "$_current",
                        style: text70.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        Padding(
          padding: kPadding10,
          child: Row(
            mainAxisAlignment: mainC,
            children: [
              if (!_isRecording)
                FlatButton(
                  color: Colors.red[400],
                  minWidth: 0,
                  padding: kPadding10.copyWith(left: 20, right: 20),
                  onPressed: () {
                    setState(() {
                      _timerVisibilty = true;
                    });
                    startTimer();
                  },
                  splashColor: secondaryColor,
                  highlightColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.white.withOpacity(0.7), width: 2),
                    borderRadius: kBorderR20,
                  ),
                  child: Row(
                    mainAxisAlignment: mainC,
                    children: [
                      Icon(
                        Icons.videocam,
                        color: Colors.white,
                      ),
                      horizontalSpaceMedium15,
                      Text(
                        "Start",
                        style: text30.copyWith(
                            color: Colors.white, fontSize: 26.sp),
                      ),
                    ],
                  ),
                ),
              if (_isRecording) Loading()
            ],
          ),
        ),
      ],
    );
  }
}

class DialogPreview extends StatefulWidget {
  final String path;
  final AttendanceUser user;
  const DialogPreview({Key key, this.path, this.user}) : super(key: key);

  @override
  _DialogPreviewState createState() => _DialogPreviewState();
}

class _DialogPreviewState extends State<DialogPreview> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  File file;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    file = File(widget.path);
    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
      });
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  updateCollection(Map<String, dynamic> mapObj) async {
    final cref = FirebaseFirestore.instance.collection("USERS");
    try {
      await cref
          .doc(widget.user.uId.getOrElse(""))
          .collection("ATTENDANCE")
          .doc("All Attendance")
          .set({
        "data": FieldValue.arrayUnion([mapObj])
      }, SetOptions(merge: true)).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: kRoundedShape,
      child: Container(
        height: screenHeight(context),
        width: screenWidth(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: kBorderR20,
        ),
        padding: kPadding20,
        child: Column(
          mainAxisAlignment: mainSB,
          children: [
            Text(
              "Confirm ?",
              style: text40,
            ),
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: ClipRRect(
                            borderRadius: kBorderR20,
                            child: VideoPlayer(_controller)),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white38,
                          size: 65.sp,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Loading();
                }
              },
            ),
            if (!loading)
              Row(
                mainAxisAlignment: mainSE,
                children: [
                  FlatButton(
                    color: secondaryColor,
                    minWidth: 0,
                    padding: kPadding10.copyWith(left: 20, right: 20),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final now = DateTime.now();
                      final String today =
                          ('${now.month.toString()}-${now.day.toString()}');
                      final String currentTime =
                          now.millisecondsSinceEpoch.toString();
                      var mapObject = new Map<String, dynamic>();

                      try {
                        final String storageId = (currentTime.toString() +
                            widget.user.uId.toString());

                        final ref = FirebaseStorage.instance
                            .ref()
                            .child("video")
                            .child(today)
                            .child(storageId);
                        final uploadTask = ref.putFile(
                            file, SettableMetadata(contentType: 'video/mp4'));

                        var downloadUrl =
                            await (await uploadTask).ref.getDownloadURL();
                        String url = downloadUrl.toString();
                        print("URL = $url");
                        setState(() {
                          mapObject["url"] = url;
                          mapObject["dateTime"] = now.millisecondsSinceEpoch;
                          loading = false;
                        });
                        await updateCollection(mapObject);
                        DisplayMessage.showSuccessMessage(
                            context, "Sent successfully");
                        Navigator.pop(context);
                      } catch (error) {
                        print(error);
                        setState(() {
                          loading = false;
                        });
                        return showToastMessage(
                            "Upload task error", Colors.red);
                      }
                    },
                    splashColor: secondaryColor,
                    highlightColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.white.withOpacity(0.7), width: 2),
                      borderRadius: kBorderR20,
                    ),
                    child: Row(
                      mainAxisAlignment: mainC,
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        horizontalSpaceTiny,
                        Text(
                          "Yes",
                          style: text30.copyWith(
                              color: Colors.white, fontSize: 26.sp),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    color: Colors.red[200],
                    minWidth: 0,
                    padding: kPadding10.copyWith(left: 20, right: 20),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    splashColor: secondaryColor,
                    highlightColor: Colors.red[200],
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.white.withOpacity(0.7), width: 2),
                      borderRadius: kBorderR20,
                    ),
                    child: Row(
                      mainAxisAlignment: mainC,
                      children: [
                        Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        horizontalSpaceTiny,
                        Text(
                          "No",
                          style: text30.copyWith(
                              color: Colors.white, fontSize: 26.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (loading)
              Center(
                child: Loading(),
              )
          ],
        ),
      ),
    );
  }
}
