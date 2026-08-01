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

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// A point on the editor canvas.
class Position extends $pb.GeneratedMessage {
  factory Position({
    $core.double? x,
    $core.double? y,
  }) {
    final result = create();
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    return result;
  }

  Position._();

  factory Position.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory Position.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Position', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'x', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'y', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Position clone() => Position()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Position copyWith(void Function(Position) updates) => super.copyWith((message) => updates(message as Position)) as Position;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Position create() => Position._();
  @$core.override
  Position createEmptyInstance() => create();
  static $pb.PbList<Position> createRepeated() => $pb.PbList<Position>();
  @$core.pragma('dart2js:noInline')
  static Position getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Position>(create);
  static Position? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);
}

/// A single mind-map node. Children are nested to preserve the tree shape.
class Node extends $pb.GeneratedMessage {
  factory Node({
    $core.String? id,
    $core.String? parentId,
    $core.String? text,
    $core.Iterable<Node>? children,
    $core.String? color,
    $core.String? icon,
    $core.String? imagePath,
    $core.bool? collapsed,
    Position? position,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (parentId != null) result.parentId = parentId;
    if (text != null) result.text = text;
    if (children != null) result.children.addAll(children);
    if (color != null) result.color = color;
    if (icon != null) result.icon = icon;
    if (imagePath != null) result.imagePath = imagePath;
    if (collapsed != null) result.collapsed = collapsed;
    if (position != null) result.position = position;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Node._();

  factory Node.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory Node.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Node', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'parentId')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..pc<Node>(4, _omitFieldNames ? '' : 'children', $pb.PbFieldType.PM, subBuilder: Node.create)
    ..aOS(5, _omitFieldNames ? '' : 'color')
    ..aOS(6, _omitFieldNames ? '' : 'icon')
    ..aOS(7, _omitFieldNames ? '' : 'imagePath')
    ..aOB(8, _omitFieldNames ? '' : 'collapsed')
    ..aOM<Position>(9, _omitFieldNames ? '' : 'position', subBuilder: Position.create)
    ..aInt64(10, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(11, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Node clone() => Node()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Node copyWith(void Function(Node) updates) => super.copyWith((message) => updates(message as Node)) as Node;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Node create() => Node._();
  @$core.override
  Node createEmptyInstance() => create();
  static $pb.PbList<Node> createRepeated() => $pb.PbList<Node>();
  @$core.pragma('dart2js:noInline')
  static Node getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Node>(create);
  static Node? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get parentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set parentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<Node> get children => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get color => $_getSZ(4);
  @$pb.TagNumber(5)
  set color($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearColor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get icon => $_getSZ(5);
  @$pb.TagNumber(6)
  set icon($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIcon() => $_has(5);
  @$pb.TagNumber(6)
  void clearIcon() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get imagePath => $_getSZ(6);
  @$pb.TagNumber(7)
  set imagePath($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasImagePath() => $_has(6);
  @$pb.TagNumber(7)
  void clearImagePath() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get collapsed => $_getBF(7);
  @$pb.TagNumber(8)
  set collapsed($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCollapsed() => $_has(7);
  @$pb.TagNumber(8)
  void clearCollapsed() => $_clearField(8);

  @$pb.TagNumber(9)
  Position get position => $_getN(8);
  @$pb.TagNumber(9)
  set position(Position value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPosition() => $_has(8);
  @$pb.TagNumber(9)
  void clearPosition() => $_clearField(9);
  @$pb.TagNumber(9)
  Position ensurePosition() => $_ensure(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get createdAt => $_getI64(9);
  @$pb.TagNumber(10)
  set createdAt($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get updatedAt => $_getI64(10);
  @$pb.TagNumber(11)
  set updatedAt($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
}

/// A whole document.
class MindMap extends $pb.GeneratedMessage {
  factory MindMap({
    $core.String? id,
    $core.String? title,
    Node? root,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (root != null) result.root = root;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  MindMap._();

  factory MindMap.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory MindMap.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MindMap', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOM<Node>(3, _omitFieldNames ? '' : 'root', subBuilder: Node.create)
    ..aInt64(4, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(5, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MindMap clone() => MindMap()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MindMap copyWith(void Function(MindMap) updates) => super.copyWith((message) => updates(message as MindMap)) as MindMap;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MindMap create() => MindMap._();
  @$core.override
  MindMap createEmptyInstance() => create();
  static $pb.PbList<MindMap> createRepeated() => $pb.PbList<MindMap>();
  @$core.pragma('dart2js:noInline')
  static MindMap getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MindMap>(create);
  static MindMap? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  Node get root => $_getN(2);
  @$pb.TagNumber(3)
  set root(Node value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRoot() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoot() => $_clearField(3);
  @$pb.TagNumber(3)
  Node ensureRoot() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get createdAt => $_getI64(3);
  @$pb.TagNumber(4)
  set createdAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get updatedAt => $_getI64(4);
  @$pb.TagNumber(5)
  set updatedAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUpdatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdatedAt() => $_clearField(5);
}

/// Lightweight metadata for listing documents without loading their trees.
class MapSummary extends $pb.GeneratedMessage {
  factory MapSummary({
    $core.String? id,
    $core.String? title,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  MapSummary._();

  factory MapSummary.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory MapSummary.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MapSummary', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aInt64(3, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(4, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MapSummary clone() => MapSummary()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MapSummary copyWith(void Function(MapSummary) updates) => super.copyWith((message) => updates(message as MapSummary)) as MapSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MapSummary create() => MapSummary._();
  @$core.override
  MapSummary createEmptyInstance() => create();
  static $pb.PbList<MapSummary> createRepeated() => $pb.PbList<MapSummary>();
  @$core.pragma('dart2js:noInline')
  static MapSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MapSummary>(create);
  static MapSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get createdAt => $_getI64(2);
  @$pb.TagNumber(3)
  set createdAt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get updatedAt => $_getI64(3);
  @$pb.TagNumber(4)
  set updatedAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdatedAt() => $_clearField(4);
}

class CreateMapRequest extends $pb.GeneratedMessage {
  factory CreateMapRequest({
    $core.String? title,
  }) {
    final result = create();
    if (title != null) result.title = title;
    return result;
  }

  CreateMapRequest._();

  factory CreateMapRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory CreateMapRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateMapRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateMapRequest clone() => CreateMapRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateMapRequest copyWith(void Function(CreateMapRequest) updates) => super.copyWith((message) => updates(message as CreateMapRequest)) as CreateMapRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateMapRequest create() => CreateMapRequest._();
  @$core.override
  CreateMapRequest createEmptyInstance() => create();
  static $pb.PbList<CreateMapRequest> createRepeated() => $pb.PbList<CreateMapRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateMapRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateMapRequest>(create);
  static CreateMapRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);
}

class GetMapRequest extends $pb.GeneratedMessage {
  factory GetMapRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  GetMapRequest._();

  factory GetMapRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory GetMapRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetMapRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMapRequest clone() => GetMapRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMapRequest copyWith(void Function(GetMapRequest) updates) => super.copyWith((message) => updates(message as GetMapRequest)) as GetMapRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMapRequest create() => GetMapRequest._();
  @$core.override
  GetMapRequest createEmptyInstance() => create();
  static $pb.PbList<GetMapRequest> createRepeated() => $pb.PbList<GetMapRequest>();
  @$core.pragma('dart2js:noInline')
  static GetMapRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetMapRequest>(create);
  static GetMapRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class ListMapsRequest extends $pb.GeneratedMessage {
  factory ListMapsRequest() => create();

  ListMapsRequest._();

  factory ListMapsRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ListMapsRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListMapsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMapsRequest clone() => ListMapsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMapsRequest copyWith(void Function(ListMapsRequest) updates) => super.copyWith((message) => updates(message as ListMapsRequest)) as ListMapsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMapsRequest create() => ListMapsRequest._();
  @$core.override
  ListMapsRequest createEmptyInstance() => create();
  static $pb.PbList<ListMapsRequest> createRepeated() => $pb.PbList<ListMapsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListMapsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListMapsRequest>(create);
  static ListMapsRequest? _defaultInstance;
}

class ListMapsResponse extends $pb.GeneratedMessage {
  factory ListMapsResponse({
    $core.Iterable<MapSummary>? maps,
  }) {
    final result = create();
    if (maps != null) result.maps.addAll(maps);
    return result;
  }

  ListMapsResponse._();

  factory ListMapsResponse.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ListMapsResponse.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListMapsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..pc<MapSummary>(1, _omitFieldNames ? '' : 'maps', $pb.PbFieldType.PM, subBuilder: MapSummary.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMapsResponse clone() => ListMapsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMapsResponse copyWith(void Function(ListMapsResponse) updates) => super.copyWith((message) => updates(message as ListMapsResponse)) as ListMapsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMapsResponse create() => ListMapsResponse._();
  @$core.override
  ListMapsResponse createEmptyInstance() => create();
  static $pb.PbList<ListMapsResponse> createRepeated() => $pb.PbList<ListMapsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListMapsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListMapsResponse>(create);
  static ListMapsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MapSummary> get maps => $_getList(0);
}

/// Replace the entire stored document (used by the editor's Save action).
class SaveMapRequest extends $pb.GeneratedMessage {
  factory SaveMapRequest({
    MindMap? map,
  }) {
    final result = create();
    if (map != null) result.map = map;
    return result;
  }

  SaveMapRequest._();

  factory SaveMapRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory SaveMapRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SaveMapRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOM<MindMap>(1, _omitFieldNames ? '' : 'map', subBuilder: MindMap.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveMapRequest clone() => SaveMapRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveMapRequest copyWith(void Function(SaveMapRequest) updates) => super.copyWith((message) => updates(message as SaveMapRequest)) as SaveMapRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SaveMapRequest create() => SaveMapRequest._();
  @$core.override
  SaveMapRequest createEmptyInstance() => create();
  static $pb.PbList<SaveMapRequest> createRepeated() => $pb.PbList<SaveMapRequest>();
  @$core.pragma('dart2js:noInline')
  static SaveMapRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SaveMapRequest>(create);
  static SaveMapRequest? _defaultInstance;

  @$pb.TagNumber(1)
  MindMap get map => $_getN(0);
  @$pb.TagNumber(1)
  set map(MindMap value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMap() => $_has(0);
  @$pb.TagNumber(1)
  void clearMap() => $_clearField(1);
  @$pb.TagNumber(1)
  MindMap ensureMap() => $_ensure(0);
}

class DeleteMapRequest extends $pb.GeneratedMessage {
  factory DeleteMapRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  DeleteMapRequest._();

  factory DeleteMapRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory DeleteMapRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteMapRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMapRequest clone() => DeleteMapRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMapRequest copyWith(void Function(DeleteMapRequest) updates) => super.copyWith((message) => updates(message as DeleteMapRequest)) as DeleteMapRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteMapRequest create() => DeleteMapRequest._();
  @$core.override
  DeleteMapRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteMapRequest> createRepeated() => $pb.PbList<DeleteMapRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteMapRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteMapRequest>(create);
  static DeleteMapRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class AddNodeRequest extends $pb.GeneratedMessage {
  factory AddNodeRequest({
    $core.String? mapId,
    $core.String? parentId,
    $core.String? text,
    Position? position,
  }) {
    final result = create();
    if (mapId != null) result.mapId = mapId;
    if (parentId != null) result.parentId = parentId;
    if (text != null) result.text = text;
    if (position != null) result.position = position;
    return result;
  }

  AddNodeRequest._();

  factory AddNodeRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory AddNodeRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddNodeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mapId')
    ..aOS(2, _omitFieldNames ? '' : 'parentId')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOM<Position>(4, _omitFieldNames ? '' : 'position', subBuilder: Position.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddNodeRequest clone() => AddNodeRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddNodeRequest copyWith(void Function(AddNodeRequest) updates) => super.copyWith((message) => updates(message as AddNodeRequest)) as AddNodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddNodeRequest create() => AddNodeRequest._();
  @$core.override
  AddNodeRequest createEmptyInstance() => create();
  static $pb.PbList<AddNodeRequest> createRepeated() => $pb.PbList<AddNodeRequest>();
  @$core.pragma('dart2js:noInline')
  static AddNodeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddNodeRequest>(create);
  static AddNodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mapId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mapId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMapId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMapId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get parentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set parentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  Position get position => $_getN(3);
  @$pb.TagNumber(4)
  set position(Position value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPosition() => $_has(3);
  @$pb.TagNumber(4)
  void clearPosition() => $_clearField(4);
  @$pb.TagNumber(4)
  Position ensurePosition() => $_ensure(3);
}

/// Only set fields are applied; use the *_set flags to distinguish "clear" from
/// "leave unchanged" for the optional string/bool fields.
class UpdateNodeRequest extends $pb.GeneratedMessage {
  factory UpdateNodeRequest({
    $core.String? mapId,
    $core.String? nodeId,
    $core.String? text,
    $core.String? color,
    $core.String? icon,
    $core.String? imagePath,
    $core.bool? collapsed,
    Position? position,
  }) {
    final result = create();
    if (mapId != null) result.mapId = mapId;
    if (nodeId != null) result.nodeId = nodeId;
    if (text != null) result.text = text;
    if (color != null) result.color = color;
    if (icon != null) result.icon = icon;
    if (imagePath != null) result.imagePath = imagePath;
    if (collapsed != null) result.collapsed = collapsed;
    if (position != null) result.position = position;
    return result;
  }

  UpdateNodeRequest._();

  factory UpdateNodeRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory UpdateNodeRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateNodeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mapId')
    ..aOS(2, _omitFieldNames ? '' : 'nodeId')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'color')
    ..aOS(5, _omitFieldNames ? '' : 'icon')
    ..aOS(6, _omitFieldNames ? '' : 'imagePath')
    ..aOB(7, _omitFieldNames ? '' : 'collapsed')
    ..aOM<Position>(8, _omitFieldNames ? '' : 'position', subBuilder: Position.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateNodeRequest clone() => UpdateNodeRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateNodeRequest copyWith(void Function(UpdateNodeRequest) updates) => super.copyWith((message) => updates(message as UpdateNodeRequest)) as UpdateNodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateNodeRequest create() => UpdateNodeRequest._();
  @$core.override
  UpdateNodeRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateNodeRequest> createRepeated() => $pb.PbList<UpdateNodeRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateNodeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateNodeRequest>(create);
  static UpdateNodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mapId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mapId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMapId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMapId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set nodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get color => $_getSZ(3);
  @$pb.TagNumber(4)
  set color($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearColor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get icon => $_getSZ(4);
  @$pb.TagNumber(5)
  set icon($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIcon() => $_has(4);
  @$pb.TagNumber(5)
  void clearIcon() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get imagePath => $_getSZ(5);
  @$pb.TagNumber(6)
  set imagePath($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasImagePath() => $_has(5);
  @$pb.TagNumber(6)
  void clearImagePath() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get collapsed => $_getBF(6);
  @$pb.TagNumber(7)
  set collapsed($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCollapsed() => $_has(6);
  @$pb.TagNumber(7)
  void clearCollapsed() => $_clearField(7);

  @$pb.TagNumber(8)
  Position get position => $_getN(7);
  @$pb.TagNumber(8)
  set position(Position value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPosition() => $_has(7);
  @$pb.TagNumber(8)
  void clearPosition() => $_clearField(8);
  @$pb.TagNumber(8)
  Position ensurePosition() => $_ensure(7);
}

class DeleteNodeRequest extends $pb.GeneratedMessage {
  factory DeleteNodeRequest({
    $core.String? mapId,
    $core.String? nodeId,
  }) {
    final result = create();
    if (mapId != null) result.mapId = mapId;
    if (nodeId != null) result.nodeId = nodeId;
    return result;
  }

  DeleteNodeRequest._();

  factory DeleteNodeRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory DeleteNodeRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteNodeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mapId')
    ..aOS(2, _omitFieldNames ? '' : 'nodeId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNodeRequest clone() => DeleteNodeRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNodeRequest copyWith(void Function(DeleteNodeRequest) updates) => super.copyWith((message) => updates(message as DeleteNodeRequest)) as DeleteNodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteNodeRequest create() => DeleteNodeRequest._();
  @$core.override
  DeleteNodeRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteNodeRequest> createRepeated() => $pb.PbList<DeleteNodeRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteNodeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteNodeRequest>(create);
  static DeleteNodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mapId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mapId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMapId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMapId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set nodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNodeId() => $_clearField(2);
}

/// Reparent a node and optionally place it at an index among its new siblings.
class MoveNodeRequest extends $pb.GeneratedMessage {
  factory MoveNodeRequest({
    $core.String? mapId,
    $core.String? nodeId,
    $core.String? newParentId,
    $core.int? index,
    Position? position,
  }) {
    final result = create();
    if (mapId != null) result.mapId = mapId;
    if (nodeId != null) result.nodeId = nodeId;
    if (newParentId != null) result.newParentId = newParentId;
    if (index != null) result.index = index;
    if (position != null) result.position = position;
    return result;
  }

  MoveNodeRequest._();

  factory MoveNodeRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory MoveNodeRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MoveNodeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mapId')
    ..aOS(2, _omitFieldNames ? '' : 'nodeId')
    ..aOS(3, _omitFieldNames ? '' : 'newParentId')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'index', $pb.PbFieldType.O3)
    ..aOM<Position>(5, _omitFieldNames ? '' : 'position', subBuilder: Position.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveNodeRequest clone() => MoveNodeRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveNodeRequest copyWith(void Function(MoveNodeRequest) updates) => super.copyWith((message) => updates(message as MoveNodeRequest)) as MoveNodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveNodeRequest create() => MoveNodeRequest._();
  @$core.override
  MoveNodeRequest createEmptyInstance() => create();
  static $pb.PbList<MoveNodeRequest> createRepeated() => $pb.PbList<MoveNodeRequest>();
  @$core.pragma('dart2js:noInline')
  static MoveNodeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MoveNodeRequest>(create);
  static MoveNodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mapId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mapId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMapId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMapId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set nodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get newParentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set newParentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewParentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewParentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get index => $_getIZ(3);
  @$pb.TagNumber(4)
  set index($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearIndex() => $_clearField(4);

  @$pb.TagNumber(5)
  Position get position => $_getN(4);
  @$pb.TagNumber(5)
  set position(Position value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPosition() => $_has(4);
  @$pb.TagNumber(5)
  void clearPosition() => $_clearField(5);
  @$pb.TagNumber(5)
  Position ensurePosition() => $_ensure(4);
}

/// Clears every node's free position so the map falls back to auto-layout.
class ResetLayoutRequest extends $pb.GeneratedMessage {
  factory ResetLayoutRequest({
    $core.String? mapId,
  }) {
    final result = create();
    if (mapId != null) result.mapId = mapId;
    return result;
  }

  ResetLayoutRequest._();

  factory ResetLayoutRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ResetLayoutRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResetLayoutRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mapId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetLayoutRequest clone() => ResetLayoutRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetLayoutRequest copyWith(void Function(ResetLayoutRequest) updates) => super.copyWith((message) => updates(message as ResetLayoutRequest)) as ResetLayoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetLayoutRequest create() => ResetLayoutRequest._();
  @$core.override
  ResetLayoutRequest createEmptyInstance() => create();
  static $pb.PbList<ResetLayoutRequest> createRepeated() => $pb.PbList<ResetLayoutRequest>();
  @$core.pragma('dart2js:noInline')
  static ResetLayoutRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResetLayoutRequest>(create);
  static ResetLayoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mapId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mapId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMapId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMapId() => $_clearField(1);
}

class UndoRequest extends $pb.GeneratedMessage {
  factory UndoRequest({
    $core.String? mapId,
  }) {
    final result = create();
    if (mapId != null) result.mapId = mapId;
    return result;
  }

  UndoRequest._();

  factory UndoRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory UndoRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UndoRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mapId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UndoRequest clone() => UndoRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UndoRequest copyWith(void Function(UndoRequest) updates) => super.copyWith((message) => updates(message as UndoRequest)) as UndoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UndoRequest create() => UndoRequest._();
  @$core.override
  UndoRequest createEmptyInstance() => create();
  static $pb.PbList<UndoRequest> createRepeated() => $pb.PbList<UndoRequest>();
  @$core.pragma('dart2js:noInline')
  static UndoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UndoRequest>(create);
  static UndoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mapId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mapId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMapId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMapId() => $_clearField(1);
}

class RedoRequest extends $pb.GeneratedMessage {
  factory RedoRequest({
    $core.String? mapId,
  }) {
    final result = create();
    if (mapId != null) result.mapId = mapId;
    return result;
  }

  RedoRequest._();

  factory RedoRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RedoRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RedoRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mindmap.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mapId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RedoRequest clone() => RedoRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RedoRequest copyWith(void Function(RedoRequest) updates) => super.copyWith((message) => updates(message as RedoRequest)) as RedoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RedoRequest create() => RedoRequest._();
  @$core.override
  RedoRequest createEmptyInstance() => create();
  static $pb.PbList<RedoRequest> createRepeated() => $pb.PbList<RedoRequest>();
  @$core.pragma('dart2js:noInline')
  static RedoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RedoRequest>(create);
  static RedoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mapId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mapId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMapId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMapId() => $_clearField(1);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
