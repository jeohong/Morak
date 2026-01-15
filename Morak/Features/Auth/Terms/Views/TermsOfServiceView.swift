//
//  TermsOfServiceView.swift
//  Morak
//
//  Created by Hong jeongmin on 1/15/26.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isAgreed: Bool = false

    var onAgree: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                }

                Spacer()

                Text("이용약관")
                    .font(.pretendard.title)

                Spacer()

                // 균형을 위한 투명 버튼
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.clear)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Divider()

            // 약관 내용
            ScrollView {
                Text(termsOfServiceContent)
                    .font(.pretendard.mediumTextRegular)
                    .foregroundColor(.textPrimary)
                    .padding(20)
            }

            Divider()

            // 동의 체크박스 및 버튼
            VStack(spacing: 16) {
                Button(action: {
                    isAgreed.toggle()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: isAgreed ? "checkmark.square.fill" : "square")
                            .font(.system(size: 24))
                            .foregroundColor(isAgreed ? .accentColor : .secondary)

                        Text("이용약관에 동의합니다")
                            .font(.pretendard.mediumTextRegular)
                            .foregroundColor(.textPrimary)

                        Spacer()
                    }
                }
                .buttonStyle(.plain)

                Button(action: {
                    onAgree()
                }) {
                    Text("동의하고 계속하기")
                        .font(.pretendard.largeTextMedium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            Color.accentColor
                                .opacity(isAgreed ? 1.0 : 0.3)
                        )
                        .cornerRadius(16)
                }
                .disabled(!isAgreed)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
    }
}

// MARK: - 이용약관 내용
private let termsOfServiceContent = """
이용약관

제1조 (목적)

본 약관은 모락(이하 "회사")가 제공하는 커뮤니티 기반 모바일 애플리케이션 및 관련 서비스(이하 "서비스")의 이용과 관련하여 회사와 회원 간의 권리, 의무, 책임사항 및 기타 필요한 사항을 규정함을 목적으로 합니다.

⸻

제2조 (용어의 정의)

1. "회원"이란 본 약관에 동의하고 회원가입을 완료하여 서비스를 이용하는 자를 의미합니다.
2. "콘텐츠"란 회원이 서비스 내에 게시, 등록, 공유하는 게시글, 댓글, 이미지, 영상, 링크, 닉네임, 프로필 정보 등 모든 정보를 의미합니다.
3. "운영자"란 서비스의 운영 및 관리를 담당하는 회사 또는 회사가 지정한 자를 의미합니다.

⸻

제3조 (약관의 효력 및 변경)

1. 본 약관은 회원이 회원가입 시 동의함으로써 효력이 발생합니다.
2. 회사는 관련 법령을 위반하지 않는 범위에서 본 약관을 변경할 수 있으며, 변경 시 앱 내 공지를 통해 사전에 안내합니다.

⸻

제4조 (콘텐츠 운영 원칙 및 금지 행위)

회원은 서비스 이용 시 다음 각 호의 콘텐츠를 게시하거나 행위하여서는 안 됩니다.

1. 타인에게 혐오감, 불쾌감 또는 정신적·신체적 피해를 유발하는 콘텐츠
2. 욕설, 비방, 모욕, 협박, 혐오 표현, 차별적 발언을 포함한 콘텐츠
3. 특정 개인 또는 집단을 대상으로 한 괴롭힘, 따돌림, 위협 행위
4. 폭력적, 잔인한 내용 또는 범죄를 조장하거나 미화하는 콘텐츠
5. 음란물, 성적 수치심을 유발하는 콘텐츠 및 미성년자에게 유해한 콘텐츠
6. 자해, 자살, 약물 오남용, 불법 행위를 조장하거나 묘사하는 콘텐츠
7. 허위 정보, 사기, 스팸, 광고성 콘텐츠 또는 반복적 게시 행위
8. 타인의 개인정보(연락처, 주소 등)를 무단으로 노출하는 콘텐츠
9. 저작권, 초상권 등 제3자의 권리를 침해하는 콘텐츠
10. 기타 관련 법령 또는 사회질서 및 공공질서에 반하는 콘텐츠

⸻

제5조 (콘텐츠 관리 및 운영자의 권한)

1. 회사는 서비스의 건전한 운영을 위하여 회원이 게시한 콘텐츠를 사전 통지 없이 검토, 수정, 차단 또는 삭제할 수 있습니다.
2. 회사는 다음 각 호에 해당하는 경우 회원의 서비스 이용을 일시적 또는 영구적으로 제한할 수 있습니다.
    1) 본 약관을 위반한 경우
    2) 다수의 신고가 접수되거나 운영 정책에 위반되는 경우
    3) 서비스 운영을 방해하거나 다른 회원에게 피해를 주는 경우
3. 회사는 콘텐츠 삭제 또는 계정 제한 조치에 대해 법적 의무가 없는 한 별도의 사전 통지 또는 개별적인 설명을 제공하지 않을 수 있습니다.

⸻

제6조 (회원의 책임)

1. 회원이 게시한 콘텐츠에 대한 책임은 해당 회원 본인에게 있습니다.
2. 회원은 본인이 게시한 콘텐츠로 인해 발생하는 모든 민·형사상 책임을 부담합니다.
3. 회사는 회원이 게시한 콘텐츠의 신뢰성, 정확성, 적법성에 대해 보증하지 않습니다.

⸻

제7조 (신고 및 조치)

1. 회원은 서비스 내 제공되는 기능을 통해 부적절한 콘텐츠를 신고할 수 있습니다.
2. 회사는 신고된 콘텐츠를 검토하여 필요 시 삭제, 이용 제한 등의 조치를 취할 수 있습니다.
3. 회사는 신고자의 신원을 외부에 공개하지 않습니다.

⸻

제8조 (서비스 이용 제한 및 회원 탈퇴)

1. 회사는 회원이 본 약관을 위반한 경우 사전 경고 없이 서비스 이용을 제한하거나 회원 자격을 박탈할 수 있습니다.
2. 회원은 언제든지 서비스 내 제공되는 방법을 통해 회원 탈퇴를 요청할 수 있습니다.

⸻

제9조 (면책 조항)

1. 회사는 회원 간 또는 회원과 제3자 간 발생한 분쟁에 개입하지 않으며, 이에 대한 책임을 지지 않습니다.
2. 회사는 회원이 게시한 콘텐츠로 인해 발생한 손해에 대하여 책임을 지지 않습니다.
3. 회사는 천재지변, 시스템 장애 등 불가피한 사유로 인한 서비스 중단에 대해 책임을 지지 않습니다.

⸻

제10조 (개인정보 보호)

회사는 관련 법령에 따라 회원의 개인정보를 보호하며, 개인정보 처리에 관한 사항은 개인정보처리방침에 따릅니다.

⸻

제11조 (준거법 및 관할)

본 약관은 대한민국 법령을 준거법으로 하며, 서비스 이용과 관련하여 발생한 분쟁은 회사의 본점 소재지를 관할하는 법원을 전속 관할로 합니다.

⸻

부칙

본 약관은 2026년 1월 15일부터 시행합니다.
"""

#Preview {
    NavigationStack {
        TermsOfServiceView(onAgree: {})
    }
}
