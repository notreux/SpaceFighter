local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script.Parent.Parent.Parent
local selectors = require(client.producers.selectors)
local producers = require(client.producers)
local React = require(ReplicatedStorage.Packages.React)
local ReactReflex = require(ReplicatedStorage.Packages.ReactReflex)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Button = require(client.ui.components.MenuButton)
local Background = require(client.ui.components.Background)
local merge = Sift.Dictionary.merge
local e = React.createElement

function Credits()
	local donors = ReactReflex.useSelector(selectors.selectDonors)
	local theme = {
		panel = Color3.fromRGB(12, 16, 24),
		panelAccent = Color3.fromRGB(20, 30, 45),
		accent = Color3.fromRGB(0, 200, 255),
		accent2 = Color3.fromRGB(255, 140, 0),
		gold = Color3.fromRGB(255, 215, 0),
		silver = Color3.fromRGB(192, 192, 192),
		bronze = Color3.fromRGB(205, 127, 50),
		text = Color3.fromRGB(255, 255, 255),
		subtext = Color3.fromRGB(180, 190, 200),
	}

	local topColors = {
		[1] = theme.gold,
		[2] = theme.silver,
		[3] = theme.bronze,
	}

	local donationAmounts = {
		[3382364248] = 100,
		[3382364728] = 250,
		[3382365403] = 500,
		[3382365688] = 1000,
		[3382365994] = 2500,
		[3382366189] = 5000,
	}

	local floatingButtons = {}
	local donorsComponents = {}

	for productId, amt in donationAmounts do
		floatingButtons[`DonateButton_{amt}`] = e(Button, {
			Text = "R$" .. tostring(amt),
			Size = UDim2.fromScale(1, 0.12),
			LayoutOrder = amt,
			OnActivated = React.useCallback(function()
				MarketplaceService:PromptProductPurchase(Players.LocalPlayer, productId)
			end, {}),
		})
	end

	for i, donor in donors do
		local color = topColors[i] or theme.accent2
		donorsComponents["Donor_" .. i] = e("Frame", {
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundColor3 = Color3.fromRGB(18, 22, 30),
			LayoutOrder = i,
			BorderSizePixel = 0,
		}, {
			NameContainer = e("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
			}, {
				Layout = e("UIListLayout", {
					Padding = UDim.new(0, 10),
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
				LeftStrip = e("Frame", {
					Size = UDim2.fromScale(0.02, 1),
					BackgroundColor3 = color,
					BorderSizePixel = 0,
					LayoutOrder = 0,
				}),
				Rank = e("TextLabel", {
					Size = UDim2.fromScale(0.05, 1),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					Text = tostring(i),
					TextColor3 = theme.subtext,
					TextScaled = true,
					Font = Enum.Font.Arcade,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 1,
				}),
				Name = e("TextLabel", {
					Size = UDim2.fromScale(0.56, 1),
					BackgroundTransparency = 1,
					Text = donor.name,
					TextColor3 = theme.text,
					TextScaled = true,
					Font = Enum.Font.Arcade,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 2,
				}),
			}),
			Amount = e("TextLabel", {
				Size = UDim2.fromScale(0.28, 1),
				Position = UDim2.fromScale(1, 0),
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Text = "R$" .. tostring(donor.amount),
				TextColor3 = (i <= 3) and theme.gold or theme.accent,
				TextScaled = true,
				Font = Enum.Font.Arcade,
				TextXAlignment = Enum.TextXAlignment.Right,
			}),
		})
	end

	return e(Background, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 0.68),
	}, {
		Layout = e("UIListLayout", {
			Padding = UDim.new(0, 10),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		FloatingButtons = e("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.02, 0.5),
			Size = UDim2.fromScale(0.4, 1),
			BackgroundTransparency = 1,
		}, {
			Layout = e("UIListLayout", {
				Padding = UDim.new(0, 20),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			Text = e("TextLabel", {
				Size = UDim2.fromScale(1, 0.12),
				BackgroundTransparency = 1,
				Text = "Support the Project!",
				TextScaled = true,
				Font = Enum.Font.Arcade,
				TextColor3 = theme.text,
			}),
			GoBackButton = e(Button, {
				Text = "Go Back",
				Size = UDim2.fromScale(0.4, 0.1),
				LayoutOrder = #donationAmounts + 1,
				OnActivated = React.useCallback(function()
					producers.setCurrentRoute("menu")
				end, {}),
			}),
			Container = e(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0.3),
				},
				merge({
					Grid = e("UIGridLayout", {
						CellPadding = UDim2.new(0, 10, 0, 8),
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						CellSize = UDim2.fromScale(0.45, 0.3),
					}),
				}, floatingButtons)
			),
		}),

		Container = e("Frame", {
			Size = UDim2.fromScale(0.5, 0.96),
			Position = UDim2.fromScale(0.20, 0.02),
			BackgroundColor3 = theme.panel,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
		}, {
			UIStroke = e("UIStroke", {
				Color = theme.panelAccent,
				Transparency = 0.1,
				Thickness = 2,
			}),
			UIPadding = e("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
			}),
			RightTitle = e("TextLabel", {
				Size = UDim2.fromScale(1, 0.12),
				Position = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1,
				Text = "Top Donors",
				TextScaled = true,
				Font = Enum.Font.Arcade,
				TextColor3 = theme.text,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),
			Scroll = e(
				"ScrollingFrame",
				{
					Position = UDim2.fromScale(0, 0.14),
					Size = UDim2.fromScale(1, 0.86),
					BackgroundColor3 = theme.panelAccent,
					BackgroundTransparency = 0,
					ScrollBarThickness = 0,
					BorderSizePixel = 0,
				},
				merge({
					UIList = e("UIListLayout", {
						Padding = UDim.new(0, 8),
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),
					UIPadding = e("UIPadding", {
						PaddingTop = UDim.new(0, 8),
						PaddingBottom = UDim.new(0, 8),
						PaddingLeft = UDim.new(0, 8),
						PaddingRight = UDim.new(0, 8),
					}),
				}, donorsComponents)
			),
		}),
	})
end
return Credits
