//
//  Generated code. Do not modify.
//  source: mindmap.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'mindmap.pb.dart' as $0;

export 'mindmap.pb.dart';

/// All mutating RPCs return the full up-to-date document so the client can
/// re-render deterministically.
@$pb.GrpcServiceName('mindmap.v1.MindMapService')
class MindMapServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  static final _$createMap = $grpc.ClientMethod<$0.CreateMapRequest, $0.MindMap>(
      '/mindmap.v1.MindMapService/CreateMap',
      ($0.CreateMapRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MindMap.fromBuffer(value));
  static final _$getMap = $grpc.ClientMethod<$0.GetMapRequest, $0.MindMap>(
      '/mindmap.v1.MindMapService/GetMap',
      ($0.GetMapRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MindMap.fromBuffer(value));
  static final _$listMaps = $grpc.ClientMethod<$0.ListMapsRequest, $0.ListMapsResponse>(
      '/mindmap.v1.MindMapService/ListMaps',
      ($0.ListMapsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ListMapsResponse.fromBuffer(value));
  static final _$saveMap = $grpc.ClientMethod<$0.SaveMapRequest, $0.MindMap>(
      '/mindmap.v1.MindMapService/SaveMap',
      ($0.SaveMapRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MindMap.fromBuffer(value));
  static final _$deleteMap = $grpc.ClientMethod<$0.DeleteMapRequest, $0.MindMap>(
      '/mindmap.v1.MindMapService/DeleteMap',
      ($0.DeleteMapRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MindMap.fromBuffer(value));
  static final _$addNode = $grpc.ClientMethod<$0.AddNodeRequest, $0.MindMap>(
      '/mindmap.v1.MindMapService/AddNode',
      ($0.AddNodeRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MindMap.fromBuffer(value));
  static final _$updateNode = $grpc.ClientMethod<$0.UpdateNodeRequest, $0.MindMap>(
      '/mindmap.v1.MindMapService/UpdateNode',
      ($0.UpdateNodeRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MindMap.fromBuffer(value));
  static final _$deleteNode = $grpc.ClientMethod<$0.DeleteNodeRequest, $0.MindMap>(
      '/mindmap.v1.MindMapService/DeleteNode',
      ($0.DeleteNodeRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MindMap.fromBuffer(value));
  static final _$moveNode = $grpc.ClientMethod<$0.MoveNodeRequest, $0.MindMap>(
      '/mindmap.v1.MindMapService/MoveNode',
      ($0.MoveNodeRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MindMap.fromBuffer(value));
  static final _$resetLayout = $grpc.ClientMethod<$0.ResetLayoutRequest, $0.MindMap>(
      '/mindmap.v1.MindMapService/ResetLayout',
      ($0.ResetLayoutRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MindMap.fromBuffer(value));
  static final _$undo = $grpc.ClientMethod<$0.UndoRequest, $0.MindMap>(
      '/mindmap.v1.MindMapService/Undo',
      ($0.UndoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MindMap.fromBuffer(value));
  static final _$redo = $grpc.ClientMethod<$0.RedoRequest, $0.MindMap>(
      '/mindmap.v1.MindMapService/Redo',
      ($0.RedoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MindMap.fromBuffer(value));

  MindMapServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.MindMap> createMap($0.CreateMapRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createMap, request, options: options);
  }

  $grpc.ResponseFuture<$0.MindMap> getMap($0.GetMapRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getMap, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListMapsResponse> listMaps($0.ListMapsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listMaps, request, options: options);
  }

  $grpc.ResponseFuture<$0.MindMap> saveMap($0.SaveMapRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$saveMap, request, options: options);
  }

  $grpc.ResponseFuture<$0.MindMap> deleteMap($0.DeleteMapRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteMap, request, options: options);
  }

  $grpc.ResponseFuture<$0.MindMap> addNode($0.AddNodeRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addNode, request, options: options);
  }

  $grpc.ResponseFuture<$0.MindMap> updateNode($0.UpdateNodeRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateNode, request, options: options);
  }

  $grpc.ResponseFuture<$0.MindMap> deleteNode($0.DeleteNodeRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteNode, request, options: options);
  }

  $grpc.ResponseFuture<$0.MindMap> moveNode($0.MoveNodeRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$moveNode, request, options: options);
  }

  $grpc.ResponseFuture<$0.MindMap> resetLayout($0.ResetLayoutRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$resetLayout, request, options: options);
  }

  $grpc.ResponseFuture<$0.MindMap> undo($0.UndoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$undo, request, options: options);
  }

  $grpc.ResponseFuture<$0.MindMap> redo($0.RedoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$redo, request, options: options);
  }
}

@$pb.GrpcServiceName('mindmap.v1.MindMapService')
abstract class MindMapServiceBase extends $grpc.Service {
  $core.String get $name => 'mindmap.v1.MindMapService';

  MindMapServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateMapRequest, $0.MindMap>(
        'CreateMap',
        createMap_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateMapRequest.fromBuffer(value),
        ($0.MindMap value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMapRequest, $0.MindMap>(
        'GetMap',
        getMap_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetMapRequest.fromBuffer(value),
        ($0.MindMap value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListMapsRequest, $0.ListMapsResponse>(
        'ListMaps',
        listMaps_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListMapsRequest.fromBuffer(value),
        ($0.ListMapsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SaveMapRequest, $0.MindMap>(
        'SaveMap',
        saveMap_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SaveMapRequest.fromBuffer(value),
        ($0.MindMap value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteMapRequest, $0.MindMap>(
        'DeleteMap',
        deleteMap_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteMapRequest.fromBuffer(value),
        ($0.MindMap value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddNodeRequest, $0.MindMap>(
        'AddNode',
        addNode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddNodeRequest.fromBuffer(value),
        ($0.MindMap value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateNodeRequest, $0.MindMap>(
        'UpdateNode',
        updateNode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateNodeRequest.fromBuffer(value),
        ($0.MindMap value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteNodeRequest, $0.MindMap>(
        'DeleteNode',
        deleteNode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteNodeRequest.fromBuffer(value),
        ($0.MindMap value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MoveNodeRequest, $0.MindMap>(
        'MoveNode',
        moveNode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MoveNodeRequest.fromBuffer(value),
        ($0.MindMap value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ResetLayoutRequest, $0.MindMap>(
        'ResetLayout',
        resetLayout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ResetLayoutRequest.fromBuffer(value),
        ($0.MindMap value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UndoRequest, $0.MindMap>(
        'Undo',
        undo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UndoRequest.fromBuffer(value),
        ($0.MindMap value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RedoRequest, $0.MindMap>(
        'Redo',
        redo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RedoRequest.fromBuffer(value),
        ($0.MindMap value) => value.writeToBuffer()));
  }

  $async.Future<$0.MindMap> createMap_Pre($grpc.ServiceCall $call, $async.Future<$0.CreateMapRequest> $request) async {
    return createMap($call, await $request);
  }

  $async.Future<$0.MindMap> getMap_Pre($grpc.ServiceCall $call, $async.Future<$0.GetMapRequest> $request) async {
    return getMap($call, await $request);
  }

  $async.Future<$0.ListMapsResponse> listMaps_Pre($grpc.ServiceCall $call, $async.Future<$0.ListMapsRequest> $request) async {
    return listMaps($call, await $request);
  }

  $async.Future<$0.MindMap> saveMap_Pre($grpc.ServiceCall $call, $async.Future<$0.SaveMapRequest> $request) async {
    return saveMap($call, await $request);
  }

  $async.Future<$0.MindMap> deleteMap_Pre($grpc.ServiceCall $call, $async.Future<$0.DeleteMapRequest> $request) async {
    return deleteMap($call, await $request);
  }

  $async.Future<$0.MindMap> addNode_Pre($grpc.ServiceCall $call, $async.Future<$0.AddNodeRequest> $request) async {
    return addNode($call, await $request);
  }

  $async.Future<$0.MindMap> updateNode_Pre($grpc.ServiceCall $call, $async.Future<$0.UpdateNodeRequest> $request) async {
    return updateNode($call, await $request);
  }

  $async.Future<$0.MindMap> deleteNode_Pre($grpc.ServiceCall $call, $async.Future<$0.DeleteNodeRequest> $request) async {
    return deleteNode($call, await $request);
  }

  $async.Future<$0.MindMap> moveNode_Pre($grpc.ServiceCall $call, $async.Future<$0.MoveNodeRequest> $request) async {
    return moveNode($call, await $request);
  }

  $async.Future<$0.MindMap> resetLayout_Pre($grpc.ServiceCall $call, $async.Future<$0.ResetLayoutRequest> $request) async {
    return resetLayout($call, await $request);
  }

  $async.Future<$0.MindMap> undo_Pre($grpc.ServiceCall $call, $async.Future<$0.UndoRequest> $request) async {
    return undo($call, await $request);
  }

  $async.Future<$0.MindMap> redo_Pre($grpc.ServiceCall $call, $async.Future<$0.RedoRequest> $request) async {
    return redo($call, await $request);
  }

  $async.Future<$0.MindMap> createMap($grpc.ServiceCall call, $0.CreateMapRequest request);
  $async.Future<$0.MindMap> getMap($grpc.ServiceCall call, $0.GetMapRequest request);
  $async.Future<$0.ListMapsResponse> listMaps($grpc.ServiceCall call, $0.ListMapsRequest request);
  $async.Future<$0.MindMap> saveMap($grpc.ServiceCall call, $0.SaveMapRequest request);
  $async.Future<$0.MindMap> deleteMap($grpc.ServiceCall call, $0.DeleteMapRequest request);
  $async.Future<$0.MindMap> addNode($grpc.ServiceCall call, $0.AddNodeRequest request);
  $async.Future<$0.MindMap> updateNode($grpc.ServiceCall call, $0.UpdateNodeRequest request);
  $async.Future<$0.MindMap> deleteNode($grpc.ServiceCall call, $0.DeleteNodeRequest request);
  $async.Future<$0.MindMap> moveNode($grpc.ServiceCall call, $0.MoveNodeRequest request);
  $async.Future<$0.MindMap> resetLayout($grpc.ServiceCall call, $0.ResetLayoutRequest request);
  $async.Future<$0.MindMap> undo($grpc.ServiceCall call, $0.UndoRequest request);
  $async.Future<$0.MindMap> redo($grpc.ServiceCall call, $0.RedoRequest request);
}
