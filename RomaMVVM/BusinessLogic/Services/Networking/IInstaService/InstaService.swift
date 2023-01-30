//
//  InstaServiceImpl.swift
//  RomaMVVM
//
//  Created by User on 30.01.2023.
//

import Combine
import CombineNetworking

protocol InstaService {
    func sendVerificationCode(emailOrPhone: String) -> AnyPublisher<String, CNError>
//    func signUp(userModel: CreateUserDataModel, completionHandler: @escaping (Results<Codable>) -> Void)
    func logInForAccessToken(emailOrPhone: String, password: String) -> AnyPublisher<String, CNError>
//    func refreshToken(token: RefreshTokenBodyDataModel?, completionHandler: @escaping (Results<RefreshTokenResponseModel>) -> Void)
//    func resetPassword(passwordsModel: ResetPasswordBodyDataModel, emailOrPhone: String, completionHandler: @escaping (Results<Codable>) -> Void)
//    func resendVerificationCode(emailOrPhone: String, completionHandler: @escaping (Results<Codable>) -> Void)
//    func verifyCode(emailOrPhone: String, code: VerifyCodeBodyDataModel, completionHandler: @escaping (Results<Codable>) -> Void)
//    func checkUserBy(nickname: String, completionHandler: @escaping (Results<Bool>) -> Void)
//    func checkUserBy(phoneOrEmail: String, completionHandler: @escaping (Results<Bool>) -> Void)
//    func updateUserProfile(userModel: UpdateUserProfileBodyDataModel,
//                           completionHandler: @escaping (Results<Codable>) -> Void)
}
