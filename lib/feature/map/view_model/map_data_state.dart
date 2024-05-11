
sealed class MapDataState {}

final class MapDataInitial extends MapDataState {}

final class MapDataLoading extends MapDataState {}

final class MapDataLoadingSuccess extends MapDataState {}

final class MapDataLoadingFailure extends MapDataState {}

// get markers from db

final class MapDataLoadingFromDb extends MapDataState {}

final class MapDataLoadingSuccessFromDb extends MapDataState {}

final class MapDataLoadingFailureFromDb extends MapDataState {}


