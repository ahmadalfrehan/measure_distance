import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlng/Controller/GeolocatorController.dart';

class ResultWithGeo extends GetView<GeoLocatorController> {
  ResultWithGeo({Key? key}) : super(key: key);
  @override
  final controller = Get.put(GeoLocatorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: Colors.teal,
                        onPressed: () {
                          controller.pickWithGeoLocator();
                          controller.update();
                        },
                        minWidth: double.infinity,
                        child: const Text('Start'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: Colors.teal,
                        onPressed: () {
                          controller.calculate();
                          controller.update();
                        },
                        minWidth: double.infinity,
                        child: const Text('Finish'),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('distance : '),
                  Text((controller.totalDistance.value * 1000).toString()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('area : '),
                  Text((controller.area.value).toString()),
                ],
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.7,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 50,
                        child: Card(
                          semanticContainer: true,
                          color: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${controller.locations[index].lat},${controller.locations[index].lng}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container();
                    },
                    itemCount: controller.locations.length,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
