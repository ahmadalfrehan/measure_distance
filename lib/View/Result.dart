import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlng/Controller/CalculateDistatanceController.dart';
import 'package:latlng/Controller/GeolocatorController.dart';

import 'CalculateDistanceLocation.dart';
import 'ResultWithGeo.dart';

class Result extends GetView<CalculateDistanceController> {
  Result({Key? key}) : super(key: key);

  @override
  final controller = Get.put(CalculateDistanceController());
  final controllerGeo = Get.put(GeoLocatorController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)
                          ),
                          child: Text(
                            (controller.totalDistance.value * 1000).toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: _showLocations(),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                controller.locations.clear();
                controller.pickCurrentLocation();
                controller.update();
              },
              child: const Text('Start'),
            ),
            FloatingActionButton(
              onPressed: () {
                controller.calculate();
                controller.update();
              },
              child: const Text('Finish'),
            ),
            FloatingActionButton(
              onPressed: () {
                Get.to(() => (ResultWithGeo()));
              },
              child: const Text('Move'),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GeolocatorWidget(),
                  ),
                );
              },
              child: const Text('Move'),
            ),
          ],
        ),
      ),
    );
  }

  _showLocations() {
    var random = Random();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.3),
        border: Border.all(color: Colors.black),
      ),
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              ((context, index) => InkWell(
                    onTap: () {},
                    child: Center(
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          '${controller.locations[index].lat} , ${controller.locations[index].lng}',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color.fromRGBO(
                              random.nextInt(255),
                              random.nextInt(155),
                              random.nextInt(255),
                              1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
              childCount: controller.locations.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisExtent: 40,
            ),
          )
        ],
      ),
    );
  }
}
