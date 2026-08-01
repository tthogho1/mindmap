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

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use positionDescriptor instead')
const Position$json = {
  '1': 'Position',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

/// Descriptor for `Position`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List positionDescriptor = $convert.base64Decode(
    'CghQb3NpdGlvbhIMCgF4GAEgASgBUgF4EgwKAXkYAiABKAFSAXk=');

@$core.Deprecated('Use nodeDescriptor instead')
const Node$json = {
  '1': 'Node',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'parent_id', '3': 2, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'children', '3': 4, '4': 3, '5': 11, '6': '.mindmap.v1.Node', '10': 'children'},
    {'1': 'color', '3': 5, '4': 1, '5': 9, '10': 'color'},
    {'1': 'icon', '3': 6, '4': 1, '5': 9, '10': 'icon'},
    {'1': 'image_path', '3': 7, '4': 1, '5': 9, '10': 'imagePath'},
    {'1': 'collapsed', '3': 8, '4': 1, '5': 8, '10': 'collapsed'},
    {'1': 'position', '3': 9, '4': 1, '5': 11, '6': '.mindmap.v1.Position', '10': 'position'},
    {'1': 'created_at', '3': 10, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 11, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Node`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodeDescriptor = $convert.base64Decode(
    'CgROb2RlEg4KAmlkGAEgASgJUgJpZBIbCglwYXJlbnRfaWQYAiABKAlSCHBhcmVudElkEhIKBH'
    'RleHQYAyABKAlSBHRleHQSLAoIY2hpbGRyZW4YBCADKAsyEC5taW5kbWFwLnYxLk5vZGVSCGNo'
    'aWxkcmVuEhQKBWNvbG9yGAUgASgJUgVjb2xvchISCgRpY29uGAYgASgJUgRpY29uEh0KCmltYW'
    'dlX3BhdGgYByABKAlSCWltYWdlUGF0aBIcCgljb2xsYXBzZWQYCCABKAhSCWNvbGxhcHNlZBIw'
    'Cghwb3NpdGlvbhgJIAEoCzIULm1pbmRtYXAudjEuUG9zaXRpb25SCHBvc2l0aW9uEh0KCmNyZW'
    'F0ZWRfYXQYCiABKANSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GAsgASgDUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use mindMapDescriptor instead')
const MindMap$json = {
  '1': 'MindMap',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'root', '3': 3, '4': 1, '5': 11, '6': '.mindmap.v1.Node', '10': 'root'},
    {'1': 'created_at', '3': 4, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 5, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
};

/// Descriptor for `MindMap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mindMapDescriptor = $convert.base64Decode(
    'CgdNaW5kTWFwEg4KAmlkGAEgASgJUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSJAoEcm9vdB'
    'gDIAEoCzIQLm1pbmRtYXAudjEuTm9kZVIEcm9vdBIdCgpjcmVhdGVkX2F0GAQgASgDUgljcmVh'
    'dGVkQXQSHQoKdXBkYXRlZF9hdBgFIAEoA1IJdXBkYXRlZEF0');

@$core.Deprecated('Use mapSummaryDescriptor instead')
const MapSummary$json = {
  '1': 'MapSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'created_at', '3': 3, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 4, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
};

/// Descriptor for `MapSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mapSummaryDescriptor = $convert.base64Decode(
    'CgpNYXBTdW1tYXJ5Eg4KAmlkGAEgASgJUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSHQoKY3'
    'JlYXRlZF9hdBgDIAEoA1IJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYBCABKANSCXVwZGF0ZWRB'
    'dA==');

@$core.Deprecated('Use createMapRequestDescriptor instead')
const CreateMapRequest$json = {
  '1': 'CreateMapRequest',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `CreateMapRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createMapRequestDescriptor = $convert.base64Decode(
    'ChBDcmVhdGVNYXBSZXF1ZXN0EhQKBXRpdGxlGAEgASgJUgV0aXRsZQ==');

@$core.Deprecated('Use getMapRequestDescriptor instead')
const GetMapRequest$json = {
  '1': 'GetMapRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetMapRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMapRequestDescriptor = $convert.base64Decode(
    'Cg1HZXRNYXBSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use listMapsRequestDescriptor instead')
const ListMapsRequest$json = {
  '1': 'ListMapsRequest',
};

/// Descriptor for `ListMapsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMapsRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0TWFwc1JlcXVlc3Q=');

@$core.Deprecated('Use listMapsResponseDescriptor instead')
const ListMapsResponse$json = {
  '1': 'ListMapsResponse',
  '2': [
    {'1': 'maps', '3': 1, '4': 3, '5': 11, '6': '.mindmap.v1.MapSummary', '10': 'maps'},
  ],
};

/// Descriptor for `ListMapsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMapsResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0TWFwc1Jlc3BvbnNlEioKBG1hcHMYASADKAsyFi5taW5kbWFwLnYxLk1hcFN1bW1hcn'
    'lSBG1hcHM=');

@$core.Deprecated('Use saveMapRequestDescriptor instead')
const SaveMapRequest$json = {
  '1': 'SaveMapRequest',
  '2': [
    {'1': 'map', '3': 1, '4': 1, '5': 11, '6': '.mindmap.v1.MindMap', '10': 'map'},
  ],
};

/// Descriptor for `SaveMapRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveMapRequestDescriptor = $convert.base64Decode(
    'Cg5TYXZlTWFwUmVxdWVzdBIlCgNtYXAYASABKAsyEy5taW5kbWFwLnYxLk1pbmRNYXBSA21hcA'
    '==');

@$core.Deprecated('Use deleteMapRequestDescriptor instead')
const DeleteMapRequest$json = {
  '1': 'DeleteMapRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteMapRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteMapRequestDescriptor = $convert.base64Decode(
    'ChBEZWxldGVNYXBSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use addNodeRequestDescriptor instead')
const AddNodeRequest$json = {
  '1': 'AddNodeRequest',
  '2': [
    {'1': 'map_id', '3': 1, '4': 1, '5': 9, '10': 'mapId'},
    {'1': 'parent_id', '3': 2, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'position', '3': 4, '4': 1, '5': 11, '6': '.mindmap.v1.Position', '10': 'position'},
  ],
};

/// Descriptor for `AddNodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addNodeRequestDescriptor = $convert.base64Decode(
    'Cg5BZGROb2RlUmVxdWVzdBIVCgZtYXBfaWQYASABKAlSBW1hcElkEhsKCXBhcmVudF9pZBgCIA'
    'EoCVIIcGFyZW50SWQSEgoEdGV4dBgDIAEoCVIEdGV4dBIwCghwb3NpdGlvbhgEIAEoCzIULm1p'
    'bmRtYXAudjEuUG9zaXRpb25SCHBvc2l0aW9u');

@$core.Deprecated('Use updateNodeRequestDescriptor instead')
const UpdateNodeRequest$json = {
  '1': 'UpdateNodeRequest',
  '2': [
    {'1': 'map_id', '3': 1, '4': 1, '5': 9, '10': 'mapId'},
    {'1': 'node_id', '3': 2, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'text', '17': true},
    {'1': 'color', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'color', '17': true},
    {'1': 'icon', '3': 5, '4': 1, '5': 9, '9': 2, '10': 'icon', '17': true},
    {'1': 'image_path', '3': 6, '4': 1, '5': 9, '9': 3, '10': 'imagePath', '17': true},
    {'1': 'collapsed', '3': 7, '4': 1, '5': 8, '9': 4, '10': 'collapsed', '17': true},
    {'1': 'position', '3': 8, '4': 1, '5': 11, '6': '.mindmap.v1.Position', '9': 5, '10': 'position', '17': true},
  ],
  '8': [
    {'1': '_text'},
    {'1': '_color'},
    {'1': '_icon'},
    {'1': '_image_path'},
    {'1': '_collapsed'},
    {'1': '_position'},
  ],
};

/// Descriptor for `UpdateNodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateNodeRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVOb2RlUmVxdWVzdBIVCgZtYXBfaWQYASABKAlSBW1hcElkEhcKB25vZGVfaWQYAi'
    'ABKAlSBm5vZGVJZBIXCgR0ZXh0GAMgASgJSABSBHRleHSIAQESGQoFY29sb3IYBCABKAlIAVIF'
    'Y29sb3KIAQESFwoEaWNvbhgFIAEoCUgCUgRpY29uiAEBEiIKCmltYWdlX3BhdGgYBiABKAlIA1'
    'IJaW1hZ2VQYXRoiAEBEiEKCWNvbGxhcHNlZBgHIAEoCEgEUgljb2xsYXBzZWSIAQESNQoIcG9z'
    'aXRpb24YCCABKAsyFC5taW5kbWFwLnYxLlBvc2l0aW9uSAVSCHBvc2l0aW9uiAEBQgcKBV90ZX'
    'h0QggKBl9jb2xvckIHCgVfaWNvbkINCgtfaW1hZ2VfcGF0aEIMCgpfY29sbGFwc2VkQgsKCV9w'
    'b3NpdGlvbg==');

@$core.Deprecated('Use deleteNodeRequestDescriptor instead')
const DeleteNodeRequest$json = {
  '1': 'DeleteNodeRequest',
  '2': [
    {'1': 'map_id', '3': 1, '4': 1, '5': 9, '10': 'mapId'},
    {'1': 'node_id', '3': 2, '4': 1, '5': 9, '10': 'nodeId'},
  ],
};

/// Descriptor for `DeleteNodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNodeRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVOb2RlUmVxdWVzdBIVCgZtYXBfaWQYASABKAlSBW1hcElkEhcKB25vZGVfaWQYAi'
    'ABKAlSBm5vZGVJZA==');

@$core.Deprecated('Use moveNodeRequestDescriptor instead')
const MoveNodeRequest$json = {
  '1': 'MoveNodeRequest',
  '2': [
    {'1': 'map_id', '3': 1, '4': 1, '5': 9, '10': 'mapId'},
    {'1': 'node_id', '3': 2, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'new_parent_id', '3': 3, '4': 1, '5': 9, '10': 'newParentId'},
    {'1': 'index', '3': 4, '4': 1, '5': 5, '10': 'index'},
    {'1': 'position', '3': 5, '4': 1, '5': 11, '6': '.mindmap.v1.Position', '10': 'position'},
  ],
};

/// Descriptor for `MoveNodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveNodeRequestDescriptor = $convert.base64Decode(
    'Cg9Nb3ZlTm9kZVJlcXVlc3QSFQoGbWFwX2lkGAEgASgJUgVtYXBJZBIXCgdub2RlX2lkGAIgAS'
    'gJUgZub2RlSWQSIgoNbmV3X3BhcmVudF9pZBgDIAEoCVILbmV3UGFyZW50SWQSFAoFaW5kZXgY'
    'BCABKAVSBWluZGV4EjAKCHBvc2l0aW9uGAUgASgLMhQubWluZG1hcC52MS5Qb3NpdGlvblIIcG'
    '9zaXRpb24=');

@$core.Deprecated('Use resetLayoutRequestDescriptor instead')
const ResetLayoutRequest$json = {
  '1': 'ResetLayoutRequest',
  '2': [
    {'1': 'map_id', '3': 1, '4': 1, '5': 9, '10': 'mapId'},
  ],
};

/// Descriptor for `ResetLayoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetLayoutRequestDescriptor = $convert.base64Decode(
    'ChJSZXNldExheW91dFJlcXVlc3QSFQoGbWFwX2lkGAEgASgJUgVtYXBJZA==');

@$core.Deprecated('Use undoRequestDescriptor instead')
const UndoRequest$json = {
  '1': 'UndoRequest',
  '2': [
    {'1': 'map_id', '3': 1, '4': 1, '5': 9, '10': 'mapId'},
  ],
};

/// Descriptor for `UndoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List undoRequestDescriptor = $convert.base64Decode(
    'CgtVbmRvUmVxdWVzdBIVCgZtYXBfaWQYASABKAlSBW1hcElk');

@$core.Deprecated('Use redoRequestDescriptor instead')
const RedoRequest$json = {
  '1': 'RedoRequest',
  '2': [
    {'1': 'map_id', '3': 1, '4': 1, '5': 9, '10': 'mapId'},
  ],
};

/// Descriptor for `RedoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redoRequestDescriptor = $convert.base64Decode(
    'CgtSZWRvUmVxdWVzdBIVCgZtYXBfaWQYASABKAlSBW1hcElk');

