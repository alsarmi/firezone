defmodule CfHttpWeb.RuleController do
  @moduledoc """
  Controller logic for Rules
  """

  use CfHttpWeb, :controller
  alias CfHttp.{Devices, Rules, Rules.Rule}

  plug CfHttpWeb.Plugs.Authenticator

  def index(conn, %{"device_id" => device_id}) do
    device = Devices.get_device!(device_id)

    render(conn, "index.html", device: device, rules: device.rules)
  end

  def new(conn, %{"device_id" => device_id}) do
    device = Devices.get_device!(device_id)

    changeset = Rules.change_rule(%Rule{device_id: device_id})
    render(conn, "new.html", changeset: changeset, device: device)
  end

  def create(conn, %{"rule" => rule_params}) do
    case Rules.create_rule(rule_params) do
      {:ok, rule} ->
        conn
        |> put_flash(:info, "Rule created successfully.")
        |> redirect(to: Routes.rule_path(conn, :show, rule))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rule = Rules.get_rule!(id)
    render(conn, "show.html", rule: rule)
  end

  def edit(conn, %{"id" => id}) do
    rule = Rules.get_rule!(id)
    changeset = Rules.change_rule(rule)

    render(conn, "edit.html", rule: rule, changeset: changeset)
  end

  def update(conn, %{"id" => id, "rule" => rule_params}) do
    rule = Rules.get_rule!(id)

    case Rules.update_rule(rule, rule_params) do
      {:ok, rule} ->
        conn
        |> put_flash(:info, "Rule updated successfully.")
        |> redirect(to: Routes.rule_path(conn, :show, rule))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", rule: rule, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rule = Rules.get_rule!(id)
    {:ok, _rule} = Rules.delete_rule(rule)

    conn
    |> put_flash(:info, "Rule deleted successfully.")
    |> redirect(to: Routes.rule_path(conn, :index, rule.device))
  end
end
