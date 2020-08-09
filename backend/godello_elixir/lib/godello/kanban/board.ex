defmodule Godello.Kanban.Board do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [:id, :name, :owner_user_id, :lists, :users, :inserted_at, :updated_at]}
  schema "boards" do
    field :name, :string
    belongs_to(:owner_user, Godello.Accounts.User)

    has_many(:lists, Godello.Kanban.List)

    many_to_many(:users, Godello.Accounts.User,
      join_through: Godello.Kanban.BoardUser,
      on_replace: :delete,
      on_delete: :delete_all
    )

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :owner_user_id])
    |> validate_required([:name, :owner_user_id])
  end

  def update_changeset(board, attrs) do
    board
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def to_basic(%__MODULE__{} = board) do
    %{board | lists: [], users: []}
  end
end