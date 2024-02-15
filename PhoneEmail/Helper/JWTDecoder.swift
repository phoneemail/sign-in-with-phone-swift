import JWTDecode

class JWTDecoder {
    
    static func decodeJWT(_ jwt: String) -> (issuer: String?, audience: String?, countryCode: String?, phoneNo: String?) {
        do {
            let jwt = try decode(jwt: jwt)

            // Access specific claims using subscript syntax
            let issuer = jwt.claim(name: "iss").string
            let audience = jwt.claim(name: "aud").string
            let countryCode = jwt.claim(name: "country_code").string
            let phoneNo = jwt.claim(name: "phone_no").string

            return (issuer, audience, countryCode, phoneNo)
        } catch {
            print("Error decoding JWT: \(error)")
            return (nil, nil, nil, nil)
        }
    }
}
