import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';




import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_map_tiles_pmtiles/vector_map_tiles_pmtiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart' as vtr;




const String tileSource = 'https://map-files.s3.ir-thr-at1.arvanstorage.ir/tehran_map.pmtiles?versionId=';

class PmTilesMap extends StatefulWidget {
 

  PmTilesMap({super.key});

  @override
  State<PmTilesMap> createState() => _PmTilesMapState();
}

class _PmTilesMapState extends State<PmTilesMap> {
  late final MapController mapController;
  final vtr.Theme mapTheme = ProtomapsThemes.lightV3(
    logger: kDebugMode ? const vtr.Logger.console() : null,
  );


  @override
  void initState() {
    mapController = MapController();
    super.initState();
  }
final _futureTileProvider = PmTilesVectorTileProvider.fromSource(tileSource);

  @override
  Widget build(BuildContext context) {

    return  FutureBuilder<PmTilesVectorTileProvider>(
        future: _futureTileProvider,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tileProvider = snapshot.data!;
            return FlutterMap(
                mapController:mapController,

                options:  const MapOptions(
                  initialCenter:  LatLng(35.761,51.432),
                  maxZoom: 18,
                  minZoom: 11,
                  initialZoom: 14,
                  interactionOptions:  InteractionOptions(
                      flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),


                ),
                children: [

                  VectorTileLayer(


                    fileCacheTtl:const Duration(hours: 1),
                    memoryTileCacheMaxSize: 10000,
                    textCacheMaxSize: 10000,
                    theme: mapTheme,
                    tileProviders: TileProviders({
                      'protomaps': tileProvider,
                    }),
                  ),


                ],


              )
            ;
          }
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            debugPrintStack(stackTrace: snapshot.stackTrace);
            return Center(child: Text(snapshot.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        },
    );
  }
}