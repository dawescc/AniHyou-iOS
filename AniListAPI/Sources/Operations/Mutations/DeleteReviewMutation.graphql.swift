// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct DeleteReviewMutation: GraphQLMutation {
  public static let operationName: String = "DeleteReview"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation DeleteReview($id: Int) { DeleteReview(id: $id) { __typename deleted } }"#
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
      .field("DeleteReview", DeleteReview?.self, arguments: ["id": .variable("id")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      DeleteReviewMutation.Data.self
    ] }

    /// Delete a review
    public var deleteReview: DeleteReview? { __data["DeleteReview"] }

    /// DeleteReview
    ///
    /// Parent Type: `Deleted`
    nonisolated public struct DeleteReview: AniListAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Deleted }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("deleted", Bool?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        DeleteReviewMutation.Data.DeleteReview.self
      ] }

      /// If an item has been successfully deleted
      public var deleted: Bool? { __data["deleted"] }
    }
  }
}
