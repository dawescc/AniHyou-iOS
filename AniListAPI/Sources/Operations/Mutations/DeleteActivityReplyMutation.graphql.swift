// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct DeleteActivityReplyMutation: GraphQLMutation {
  public static let operationName: String = "DeleteActivityReply"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation DeleteActivityReply($id: Int) { DeleteActivityReply(id: $id) { __typename deleted } }"#
    ))

  public var id: GraphQLNullable<Int32>

  public init(id: GraphQLNullable<Int32>) {
    self.id = id
  }

  @_spi(Unsafe) public var __variables: Variables? { ["id": id] }

  nonisolated public struct Data: AniListAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("DeleteActivityReply", DeleteActivityReply?.self, arguments: ["id": .variable("id")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      DeleteActivityReplyMutation.Data.self
    ] }

    /// Delete an activity reply of the authenticated users
    public var deleteActivityReply: DeleteActivityReply? { __data["DeleteActivityReply"] }

    /// DeleteActivityReply
    ///
    /// Parent Type: `Deleted`
    nonisolated public struct DeleteActivityReply: AniListAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Deleted }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("deleted", Bool?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        DeleteActivityReplyMutation.Data.DeleteActivityReply.self
      ] }

      /// If an item has been successfully deleted
      public var deleted: Bool? { __data["deleted"] }
    }
  }
}
