You are a senior Flutter Web engineer and SaaS UI/UX designer.

Build a Flutter Web application (WEB ONLY, not mobile)
whose purpose is to help investors understand revenue,
monthly income, and company valuation.

This is a DEMO application:
- No backend
- No Firebase
- No API calls
- No authentication
- All values are local state only
- For understanding and presentations only

--------------------------------------------------
TECH STACK
--------------------------------------------------
- Flutter (latest stable)
- Target platform: Flutter Web
- State management: setState / ValueNotifier
- Animations: AnimatedSwitcher, TweenAnimationBuilder
- Layout: Responsive for large screens (1200px+)

--------------------------------------------------
DESIGN SYSTEM (MONDAY.COM STYLE)
--------------------------------------------------
- Background: Pure white (#FFFFFF)
- Section background: Light grey (#F7F8FA)
- Primary color: Blue (#0073EA)
- Accent color: Green (#00C875)
- Text color: Dark grey (#323338)
- Border radius: 14px
- Shadows: Soft elevation (blur 12, opacity 0.08)
- Font style: Clean SaaS typography (use default Flutter fonts)
- Spacing: Generous padding and margins

UI principles:
- Minimal
- Premium
- Investor-friendly
- Easy to understand numbers
- Smooth animations when values change

--------------------------------------------------
APP STRUCTURE
--------------------------------------------------

Single page scrollable dashboard with these sections:

1. Header
2. Pricing & Users
3. Revenue Breakdown
4. Investor Income
5. Valuation & Equity
6. Withdraw Dialog

--------------------------------------------------
HEADER SECTION
--------------------------------------------------
- Title: "Investor Revenue Dashboard"
- Subtitle:
  "Understand monthly revenue, income distribution,
   and company valuation in real time."

--------------------------------------------------
PRICING & USERS SECTION
--------------------------------------------------

Create a responsive 3-column grid of cards.

CARD 1:
- Title: Creators
- Price label: AED 199 / user / month

CARD 2:
- Title: SMEs
- Price label: AED 499 / user / month

CARD 3:
- Title: Agencies
- Price label: AED 2999 / user / month

Each card must contain:
- Number TextField: "Number of Users"
- Display calculated monthly revenue
- Use animation when numbers update
- Rounded corners, soft shadow
- Hover effect using MouseRegion

--------------------------------------------------
REVENUE CALCULATION LOGIC
--------------------------------------------------

Creators Revenue  = creatorsCount × 199
SMEs Revenue      = smesCount × 499
Agencies Revenue  = agenciesCount × 2999

Total Monthly Revenue (MRR) =
Creators Revenue + SMEs Revenue + Agencies Revenue

Display MRR in a highlighted summary card.

--------------------------------------------------
INVESTOR REVENUE LOGIC (IMPORTANT)
--------------------------------------------------

Investor Revenue Pool = Total Monthly Revenue × 20%

Investor Monthly Income =
Investor Revenue Pool × (Investor Revenue Share %) / 100

Input:
- Revenue Share % (default value: 1.3333%)

Clearly label:
"Only 20% of total revenue is distributed to investors."

--------------------------------------------------
TOTAL INCOME TILL DATE
--------------------------------------------------

Input:
- "Months Since Launch" (default: 6)

Total Income Till Date =
Investor Monthly Income × Months Since Launch

Show this as a bold highlighted value.

--------------------------------------------------
VALUATION & EQUITY SECTION
--------------------------------------------------

Company Valuation =
Total Monthly Revenue × 12 × 5

Input:
- Investor Equity % (default: 1%)

Equity Value =
Company Valuation × (Investor Equity %) / 100

Add helper text:
"Valuation is based on 5× annual recurring revenue."

--------------------------------------------------
WITHDRAW BUTTON & DIALOG
--------------------------------------------------

Add a primary button:
"Withdraw to Bank Account"

On click:
- Open a centered modal dialog

Dialog must show:
- Revenue Share %
- Total Income Till Date
- Equity Value
- Divider
- Informational note:

  "This is a demo dashboard.
   No real money, banking, or withdrawals are involved."

--------------------------------------------------
WIDGET STRUCTURE EXPECTATION
--------------------------------------------------

Organize widgets cleanly:
- PricingCard widget
- SummaryCard widget
- CalculationSection widget
- WithdrawDialog widget

Keep calculation logic readable and commented.

--------------------------------------------------
OUTPUT EXPECTATION
--------------------------------------------------

- Fully working Flutter Web app
- Clean UI
- Correct calculations
- Investor-grade clarity
- No backend
- No mock APIs
- Ready for demo & screen sharing

Build the complete Flutter Web project.
