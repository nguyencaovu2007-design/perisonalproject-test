extension Color {
    static let appPrimary    = Color(red: 0.58, green: 0.27, blue: 1.00)
    static let appSecondary  = Color(red: 0.75, green: 0.45, blue: 1.00)
    static let cosmicBlue    = Color(red: 0.20, green: 0.50, blue: 1.00)
    static let cosmicPink    = Color(red: 1.00, green: 0.35, blue: 0.75)
    static let cosmicCyan    = Color(red: 0.10, green: 0.85, blue: 0.95)
    static let cosmicGold    = Color(red: 1.00, green: 0.82, blue: 0.20)
    static let spaceBlack    = Color(red: 0.04, green: 0.03, blue: 0.08)
    static let spaceDark     = Color(red: 0.07, green: 0.05, blue: 0.14)
    static let spaceCard     = Color(red: 0.10, green: 0.08, blue: 0.20)
    static let spaceElevated = Color(red: 0.14, green: 0.11, blue: 0.26)
    static let appGreen      = Color(red: 0.18, green: 0.95, blue: 0.65)
    static let appRed        = Color(red: 1.00, green: 0.30, blue: 0.45)
    static let appOrange     = Color(red: 1.00, green: 0.62, blue: 0.10)
    static let appIndigo     = Color(red: 0.40, green: 0.30, blue: 1.00)
}

// MARK: - Gradients  (computed — avoids Swift stored-property restriction)

enum CG {
    static var button: LinearGradient {
        LinearGradient(colors: [Color(red: 0.70, green: 0.30, blue: 1.00),
                                Color(red: 0.45, green: 0.15, blue: 0.90)],
                       startPoint: .leading, endPoint: .trailing)
    }
    static var header: LinearGradient {
        LinearGradient(colors: [Color(red: 0.12, green: 0.04, blue: 0.28),
                                Color(red: 0.08, green: 0.03, blue: 0.18)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    static var promo: LinearGradient {
        LinearGradient(colors: [.appPrimary, Color(red: 0.90, green: 0.20, blue: 0.80)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    static var cardBorder: LinearGradient {
        LinearGradient(colors: [Color.appPrimary.opacity(0.5),
                                Color.cosmicBlue.opacity(0.2), .clear],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    static var balanceText: LinearGradient {
        LinearGradient(colors: [.white, .appSecondary],
                       startPoint: .leading, endPoint: .trailing)
    }
}

// MARK: - Spacing & Radius

enum AppSpacing {
    static let xs: CGFloat  = 4
    static let sm: CGFloat  = 8
    static let md: CGFloat  = 12
    static let lg: CGFloat  = 16
    static let xl: CGFloat  = 20
    static let xxl: CGFloat = 24
}

enum AppRadius {
    static let sm: CGFloat   = 10
    static let md: CGFloat   = 14
    static let lg: CGFloat   = 20
    static let pill: CGFloat = 999
}

// MARK: - View helpers

extension View {
    func appCardShadow() -> some View {
        self
            .shadow(color: Color.appPrimary.opacity(0.15), radius: 20, x: 0, y: 4)
            .shadow(color: .black.opacity(0.30), radius: 6, x: 0, y: 2)
    }
    func appElevatedShadow() -> some View {
        self
            .shadow(color: Color.appPrimary.opacity(0.25), radius: 30, x: 0, y: 8)
            .shadow(color: .black.opacity(0.40), radius: 10, x: 0, y: 4)
    }
    func appButtonShadow(color: Color) -> some View {
        self
            .shadow(color: color.opacity(0.55), radius: 16, x: 0, y: 8)
            .shadow(color: color.opacity(0.25), radius: 4,  x: 0, y: 2)
    }
    func cosmicGlow(color: Color, radius: CGFloat = 10) -> some View {
        self
            .shadow(color: color.opacity(0.65), radius: radius)
            .shadow(color: color.opacity(0.25), radius: radius * 2)
    }
}

// MARK: - Button Style

struct CosmicButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .brightness(configuration.isPressed ? 0.06 : 0)
            .animation(.spring(response: 0.22, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - StarfieldView

struct StarfieldView: View {
    let starCount: Int
    private let phases: [Double]

    init(starCount: Int = 60) {
        self.starCount = starCount
        self.phases    = (0..<starCount).map { Double($0) * 0.618 * .pi * 2 }
    }

    var body: some View {
        TimelineView(.animation) { tl in
            Canvas { ctx, size in
                let now = tl.date.timeIntervalSinceReferenceDate
                for i in 0..<starCount {
                    let seed  = Double(i) * 137.508
                    let x     = (sin(seed * 0.7) * 0.5 + 0.5) * size.width
                    let y     = (cos(seed * 1.3) * 0.5 + 0.5) * size.height
                    let base  = (sin(seed * 2.1) * 0.5 + 0.5) * 2.0 + 0.5
                    let twink = sin(now * 1.4 + phases[i]) * 0.5 + 0.5
                    let op    = 0.25 + twink * 0.60
                    let sz    = base * (0.7 + twink * 0.4)
                    let cs    = sin(seed * 3.7)
                    let c: Color = cs > 0.5 ? .cosmicCyan : cs > 0.0 ? .white : cs > -0.4 ? .appSecondary : .cosmicGold
                    ctx.fill(Path(ellipseIn: CGRect(x: x - sz/2, y: y - sz/2, width: sz, height: sz)),
                             with: .color(c.opacity(op)))
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - NebulaBackground

struct NebulaBackground: View {
    var body: some View {
        ZStack {
            Color.spaceBlack
            Circle()
                .fill(RadialGradient(colors: [Color.appPrimary.opacity(0.35), .clear],
                                     center: .center, startRadius: 0, endRadius: 180))
                .frame(width: 360).offset(x: -80, y: -200).blur(radius: 20)
            Circle()
                .fill(RadialGradient(colors: [Color.cosmicBlue.opacity(0.22), .clear],
                                     center: .center, startRadius: 0, endRadius: 140))
                .frame(width: 280).offset(x: 120, y: 100).blur(radius: 15)
            Circle()
                .fill(RadialGradient(colors: [Color.cosmicPink.opacity(0.16), .clear],
                                     center: .center, startRadius: 0, endRadius: 120))
                .frame(width: 240).offset(x: -60, y: 320).blur(radius: 18)
            StarfieldView(starCount: 80)
        }
        .ignoresSafeArea()
    }
}

// MARK: - Currency

extension Double {
    var vndFormatted: String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = "."
        return (f.string(from: NSNumber(value: Int(Swift.abs(self)))) ?? "\(Int(Swift.abs(self)))") + " đ"
    }
    var vndCompact: String {
        let a = Swift.abs(self)
        if a >= 1_000_000_000 { return String(format: "%.1fT đ", a / 1_000_000_000) }
        if a >= 1_000_000     { return String(format: "%.1fM đ", a / 1_000_000) }
        if a >= 1_000         { return String(format: "%.0fK đ", a / 1_000) }
        return vndFormatted
    }
}

// MARK: - Models

struct Transaction: Identifiable {
    let id = UUID()
    let title, subtitle: String
    let amount: Double
    let isCredit: Bool
    let icon: String
    let iconColor: Color
    let date: String
}

struct ServiceItem: Identifiable {
    let id = UUID()
    let title, icon: String
    let color: Color
    let badge: String?
}

struct PromoItem: Identifiable {
    let id = UUID()
    let title, subtitle, icon: String
    let color: Color
}

struct BankItem: Identifiable {
    let id = UUID()
    let name, shortName, icon: String
    let color: Color
}

struct MenuRow: Identifiable {
    let id = UUID()
    let icon: String
    let color: Color
    let title: String
    let subtitle: String?
}

// MARK: - Mock Data

struct MoMoData {
    static let transactions: [Transaction] = [
        .init(title: "Nạp tiền điện thoại",   subtitle: "Viettel • 0987 654 321", amount: -100_000, isCredit: false, icon: "iphone.radiowaves.left.and.right", iconColor: .appPrimary, date: "Hôm nay, 14:32"),
        .init(title: "Nhận tiền từ Minh Tuấn", subtitle: "Chuyển khoản",           amount:  500_000, isCredit: true,  icon: "arrow.down.left.circle.fill",     iconColor: .appGreen,   date: "Hôm nay, 11:15"),
        .init(title: "Thanh toán điện",         subtitle: "EVN TP.HCM",             amount: -215_000, isCredit: false, icon: "bolt.circle.fill",                iconColor: .appOrange,  date: "Hôm qua, 09:00"),
        .init(title: "Mua vé phim",             subtitle: "CGV Vincom",             amount: -160_000, isCredit: false, icon: "film.circle.fill",                iconColor: .cosmicPink, date: "Hôm qua, 20:45"),
        .init(title: "Hoàn tiền Ví",            subtitle: "Ưu đãi hoàn tiền",       amount:   15_000, isCredit: true,  icon: "sparkles",                        iconColor: .cosmicGold, date: "23/06, 00:01"),
        .init(title: "Grab - Đặt xe",           subtitle: "Grab Vietnam",           amount:  -45_000, isCredit: false, icon: "car.fill",                        iconColor: .appGreen,   date: "22/06, 18:22"),
        .init(title: "Chuyển tiền cho Lan",     subtitle: "Chuyển khoản",           amount: -200_000, isCredit: false, icon: "arrow.up.right.circle.fill",      iconColor: .appRed,     date: "22/06, 12:00"),
    ]

    static let services: [ServiceItem] = [
        .init(title: "Nạp tiền",    icon: "bolt.fill",                 color: .appPrimary, badge: nil),
        .init(title: "Chuyển tiền", icon: "paperplane.fill",           color: .appGreen,   badge: nil),
        .init(title: "Thanh toán",  icon: "qrcode",                    color: .cosmicCyan, badge: nil),
        .init(title: "Điện, nước",  icon: "lightbulb.fill",            color: .appOrange,  badge: nil),
        .init(title: "Mua sắm",     icon: "bag.fill",                  color: .cosmicPink, badge: "HOT"),
        .init(title: "Đặt vé",      icon: "ticket.fill",               color: .cosmicGold, badge: nil),
        .init(title: "Bảo hiểm",   icon: "shield.fill",               color: .appRed,     badge: nil),
        .init(title: "Đầu tư",      icon: "chart.line.uptrend.xyaxis", color: .cosmicBlue, badge: "MỚI"),
    ]

    static let promotions: [PromoItem] = [
        .init(title: "Hoàn tiền 30%",      subtitle: "Thanh toán tại Highlands Coffee", icon: "cup.and.saucer.fill", color: .appOrange),
        .init(title: "Giảm 50k",            subtitle: "Đặt xe Grab lần đầu qua Ví",      icon: "car.fill",            color: .appGreen),
        .init(title: "Tặng 20k",            subtitle: "Nạp tiền điện thoại từ 100k",     icon: "bolt.fill",           color: .appPrimary),
        .init(title: "0đ phí chuyển",       subtitle: "Chuyển tiền đến mọi ngân hàng",   icon: "paperplane.fill",     color: .cosmicCyan),
        .init(title: "Hoàn tiền 15%",       subtitle: "Thanh toán tại Circle K, GS25",   icon: "cart.fill",           color: .cosmicPink),
        .init(title: "Miễn phí vận chuyển", subtitle: "Mua hàng qua Mall",               icon: "shippingbox.fill",    color: .cosmicGold),
    ]

    static let banks: [BankItem] = [
        .init(name: "Vietcombank", shortName: "VCB",  icon: "building.columns.fill", color: .appGreen),
        .init(name: "Techcombank", shortName: "TCB",  icon: "building.columns.fill", color: .appRed),
        .init(name: "BIDV",        shortName: "BIDV", icon: "building.columns.fill", color: .appPrimary),
        .init(name: "MB Bank",     shortName: "MB",   icon: "building.columns.fill", color: .cosmicBlue),
        .init(name: "VPBank",      shortName: "VPB",  icon: "building.columns.fill", color: .appOrange),
        .init(name: "ACB",         shortName: "ACB",  icon: "building.columns.fill", color: .cosmicCyan),
        .init(name: "TPBank",      shortName: "TPB",  icon: "building.columns.fill", color: .cosmicPink),
        .init(name: "Sacombank",   shortName: "STB",  icon: "building.columns.fill", color: .cosmicGold),
    ]
}

// MARK: - ViewModels
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var balance: Double  = 555_555_555
    @Published var isBalanceHidden  = false
    @Published var transactions     = MoMoData.transactions
    @Published var services         = MoMoData.services
    @Published var isRefreshing     = false
    @Published var userName         = "Vũ Cao Nguyên"
    @Published var hasNotification  = true

    var displayBalance: String { isBalanceHidden ? "••••••••" : balance.vndFormatted }
    var initials: String {
        let p = userName.split(separator: " ")
        return "\(p.first?.prefix(1) ?? "")\(p.last?.prefix(1) ?? "")"
    }
    func toggleBalance() { withAnimation(.spring(response: 0.3)) { isBalanceHidden.toggle() } }
    func refresh() async {
        isRefreshing = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isRefreshing = false
    }
}

@MainActor
class WalletViewModel: ObservableObject {
    struct ContactItem: Identifiable, Equatable {
        let id = UUID()
        let name, initials, phone: String
        let color: Color
        static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    }

    @Published var rawAmount      = ""
    @Published var recipientPhone = ""
    @Published var selectedContact: ContactItem? = nil
    @Published var showConfirmation = false
    @Published var note           = ""
    @Published var selectedBank: BankItem? = nil

    let quickAmounts: [Double] = [50_000, 100_000, 200_000, 500_000, 1_000_000, 2_000_000]
    let recentContacts: [ContactItem] = [
        .init(name: "Minh Tuấn", initials: "MT", phone: "0912 345 678", color: .appPrimary),
        .init(name: "Thùy Lan",  initials: "TL", phone: "0987 654 321", color: .cosmicPink),
        .init(name: "Hải Long",  initials: "HL", phone: "0901 234 567", color: .appGreen),
        .init(name: "Phương",    initials: "PT", phone: "0976 543 210", color: .cosmicCyan),
    ]

    var amountValue: Double? { Double(rawAmount) }
    var canProceed:  Bool    { !recipientPhone.isEmpty && (amountValue ?? 0) > 0 }

    func selectQuick(_ a: Double)       { rawAmount = "\(Int(a))" }
    func isSelected(_ a: Double) -> Bool { amountValue == a }
    func selectContact(_ c: ContactItem) { selectedContact = c; recipientPhone = c.phone }
    func clearPhone()                    { recipientPhone = ""; selectedContact = nil }

    func formatted(_ raw: String) -> String {
        guard let v = Double(raw) else { return raw }
        let f = NumberFormatter(); f.numberStyle = .decimal; f.groupingSeparator = "."
        return f.string(from: NSNumber(value: Int(v))) ?? raw
    }
}

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var userName = "Vũ Cao Nguyên"
    @Published var phone    = "0941 338 447"
    var initials: String {
        let p = userName.split(separator: " ")
        return "\(p.first?.prefix(1) ?? "")\(p.last?.prefix(1) ?? "")"
    }
}
