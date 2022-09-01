// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;


import "./EgitimBilgileri.sol";
import "./YabanciDilBilgileri.sol";
import "./KursBilgileri.sol";
import "./NitelikBilgileri.sol";
import "./CalismaBilgileri.sol";
import "./SertifikaBilgileri.sol";

contract Talep is BaseContract{



EgitimBilgileri egitimKontrati;
CalismaBilgileri calismaKontrati;
YabanciDilBilgileri yabanciDilKontrati;
KursBilgileri kursKontrati;
NitelikBilgileri nitelikKontrati;
SertifikaBilgileri sertifikaKontrati;


    constructor(address _egitimKontrati,address _calismaKontrati, address _yabanciDilKontrati, address _kursKontrati, address _nitelikKontrati,address _sertifikaKontrati)  {
        egitimKontrati=EgitimBilgileri(_egitimKontrati);
        calismaKontrati=CalismaBilgileri(_calismaKontrati);
        yabanciDilKontrati=YabanciDilBilgileri(_yabanciDilKontrati);
        kursKontrati=KursBilgileri(_kursKontrati);
        nitelikKontrati=NitelikBilgileri(_nitelikKontrati);
        sertifikaKontrati=SertifikaBilgileri(_sertifikaKontrati);
    }




    
}