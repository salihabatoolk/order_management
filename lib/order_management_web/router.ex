defmodule OrderManagementWeb.Router do
  use OrderManagementWeb, :router

  import OrderManagementWeb.UserAuth

  # =========================================================
  # BROWSER PIPELINE
  # =========================================================

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {OrderManagementWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  # =========================================================
  # API PIPELINE
  # =========================================================

  pipeline :api do
    plug :accepts, ["json"]
  end

  # =========================================================
  # PROTECTED APPLICATION ROUTES
  # =========================================================
  # Login is required for these pages.
  # =========================================================

  scope "/", OrderManagementWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", PageController, :home

    resources "/orders", OrderController

    resources "/customers", CustomerController
  end

  # =========================================================
  # DEVELOPMENT ROUTES
  # =========================================================

  if Application.compile_env(:order_management, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard",
        metrics: OrderManagementWeb.Telemetry

      forward "/mailbox",
        Plug.Swoosh.MailboxPreview
    end
  end

  # =========================================================
  # AUTHENTICATED USER ROUTES
  # =========================================================
  # Only logged-in users can access these.
  # =========================================================

  scope "/", OrderManagementWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{OrderManagementWeb.UserAuth, :require_authenticated}] do

      live "/users/settings",
        UserLive.Settings,
        :edit

      live "/users/settings/confirm-email/:token",
        UserLive.Settings,
        :confirm_email
    end

    post "/users/update-password",
      UserSessionController,
      :update_password
  end

  # =========================================================
  # PUBLIC AUTHENTICATION ROUTES
  # =========================================================
  # Login/Register are available without authentication.
  # =========================================================

  scope "/", OrderManagementWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{OrderManagementWeb.UserAuth, :mount_current_scope}] do

      live "/users/register",
        UserLive.Registration,
        :new

      live "/users/log-in",
        UserLive.Login,
        :new

      live "/users/log-in/:token",
        UserLive.Confirmation,
        :new
    end

    post "/users/log-in",
      UserSessionController,
      :create

    delete "/users/log-out",
      UserSessionController,
      :delete
  end
end
