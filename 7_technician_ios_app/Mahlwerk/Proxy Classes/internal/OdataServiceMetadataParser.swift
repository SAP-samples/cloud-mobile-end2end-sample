// # Proxy Compiler 19.9.1-a703a1-20191107

import Foundation
import SAPOData

internal class OdataServiceMetadataParser {
    internal static let options: Int = (CSDLOption.allowCaseConflicts | CSDLOption.disableFacetWarnings | CSDLOption.disableNameValidation | CSDLOption.processMixedVersions | CSDLOption.retainOriginalText | CSDLOption.ignoreUndefinedTerms)

    internal static let parsed: CSDLDocument = OdataServiceMetadataParser.parse()

    static func parse() -> CSDLDocument {
        let parser = CSDLParser()
        parser.logWarnings = false
        parser.csdlOptions = OdataServiceMetadataParser.options
        let metadata = parser.parseInProxy(OdataServiceMetadataText.xml, url: "com.sap.odata")
        metadata.proxyVersion = "19.9.1-a703a1-20191107"
        return metadata
    }
}
