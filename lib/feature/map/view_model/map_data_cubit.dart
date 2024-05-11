import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/feature/map/view_model/map_data_state.dart';


class MapDataCubit extends Cubit<MapDataState> {
  MapDataCubit() : super(MapDataInitial());

  MapDataCubit get(context) => BlocProvider.of(context);

  var db = FirebaseFirestore.instance;

  Future<void> addMarkerToDb  (String title , double lat , double lng  , String sinpset) async {
    debugPrint('addMarkerToDb');
    emit(MapDataLoading());
    try{
      await db.collection('markers').doc().set({
        'title': title,
        'lat': lat,
        'lng': lng,
        'sinpset': sinpset
      });
      emit(MapDataLoadingSuccess());

    }catch(e){
      print(e);
      emit(MapDataLoadingFailure());
    }


  }

  Set<Marker> markers = {};  // markers['lat']
  Future<void> getMarkersFromDb() async {
    debugPrint('getMarkersFromDb');
    emit(MapDataLoadingFromDb());
    try{
      await db.collection('markers').get().then((value) {
        value.docs.forEach((element) {
          markers.add(Marker(
            markerId: MarkerId(element['title']),
            position: LatLng(element['lat'], element['lng']),
            infoWindow: InfoWindow(title: element['title'], snippet: element['sinpset']),
          ));
        });
      });
      emit(MapDataLoadingSuccessFromDb());
    }catch(e){
      print(e);
      emit(MapDataLoadingFailureFromDb());
    }
  }





}
