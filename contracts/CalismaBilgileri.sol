// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
//pragma experimental ABIEncoderV2;
import "./BaseContract.sol";
import "./BaseProperties.sol";

contract CalismaBilgileri is BaseProperties {
    uint public id;
    BaseContract baseContract;

    struct CalismaBilgi {
        uint id;
        address talepEdilenKurum;
        string pozisyon;
        string sektor;
        CalismaTipi calismaTipi;
        string isAciklama;
        uint basTarih;
        uint bitTarih;
        uint8 ulke;
        uint32 sehir;
        Onay onayBilgi;
    }


    mapping(address => mapping(uint => CalismaBilgi)) public calismaBilgiListesi;
    mapping(address => CalismaBilgi[]) public calismaBilgiListesi2;
    address[] public onayBekleyenKisiler;
    CalismaBilgi[] public calismaBilgileri;
    mapping(address => uint[]) public kisiCalismaIdListesi;

    event CalismaBilgiEklendiLog(address _kisiAdres, uint8 _ulke, string _pozisyon, string _sektor);
    event CalismaBilgiGuncellendiLog(address _kisiAdres, uint8 _ulke, string _pozisyon, string _sektor);
    event CalismaBilgiTalepEdildiLog(address _talepEdilenKurum, uint8 _ulke, string _pozisyon, string _sektor);
    event CalismaTalebiOnaylandiLog(address _onayKurumAdres, uint _tarih);
    constructor(address baseAddress)  {
        baseContract = BaseContract(baseAddress);
        id = 1;
    }
    modifier _yetkiliPaydas{
        require(baseContract.isUniversite(msg.sender) || baseContract.isFirma(msg.sender) || baseContract.isKamuKurumu(msg.sender),
            "Sadece yetkili paydas bu islemi yapabilir."
        );
        _;
    }
    modifier _sadeceKisi{
        require(baseContract.isKisi(msg.sender),
            "Bu islemi sadece Kisi yapabilir."
        );
        _;
    }
    function ekleCalismaBilgi(address _kisiAddress,   string memory pozisyon,   string memory sektor, CalismaTipi calismaTipi, 
    string memory isAciklama, uint basTarih, uint bitTarih, uint8 ulke, uint32 sehir) public _yetkiliPaydas {
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        uint yeniId = id++;

        calismaBilgiListesi[_kisiAddress][yeniId].id = yeniId;
        calismaBilgiListesi[_kisiAddress][yeniId].pozisyon = pozisyon;
        calismaBilgiListesi[_kisiAddress][yeniId].sektor = sektor;
        calismaBilgiListesi[_kisiAddress][yeniId].calismaTipi = calismaTipi;
        calismaBilgiListesi[_kisiAddress][yeniId].isAciklama = isAciklama;
        calismaBilgiListesi[_kisiAddress][yeniId].basTarih = basTarih;
        calismaBilgiListesi[_kisiAddress][yeniId].bitTarih = bitTarih;
        calismaBilgiListesi[_kisiAddress][yeniId].ulke = ulke;
        calismaBilgiListesi[_kisiAddress][yeniId].sehir = sehir;
        calismaBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman = block.timestamp;
        calismaBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.Onaylandi;
        calismaBilgiListesi[_kisiAddress][yeniId].onayBilgi.adres = msg.sender;
        kisiCalismaIdListesi[_kisiAddress].push(yeniId);
        emit CalismaBilgiEklendiLog(_kisiAddress, ulke, pozisyon, sektor);
    }

    function guncelleCalismaBilgi(address _kisiAddress, uint _calismaBilgiId, string memory pozisyon, string memory sektor, CalismaTipi calismaTipi, string memory isAciklama, uint basTarih, uint bitTarih, uint8 ulke, uint32 sehir) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(calismaBilgiListesi[_kisiAddress][_calismaBilgiId].id > 1, "Kisinin bu adres ve calisma id degeri ile kaydi yoktur.");
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].pozisyon = pozisyon;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].sektor = sektor;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].calismaTipi = calismaTipi;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].isAciklama = isAciklama;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].basTarih = basTarih;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].bitTarih = bitTarih;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].ulke = ulke;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].sehir = sehir;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].onayBilgi.zaman = block.timestamp;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].onayBilgi.adres = msg.sender;

        emit CalismaBilgiGuncellendiLog(_kisiAddress, ulke, pozisyon, sektor);
        return _calismaBilgiId;

    }

    function talepEtCalismaBilgi(address _kisiAddress, address _talepEdilenKurum, string memory pozisyon, string memory sektor, CalismaTipi calismaTipi, string memory isAciklama, uint basTarih, uint bitTarih, uint8 ulke, uint32 sehir) public {
        require(baseContract.isKisi(_kisiAddress), "Kisi Mevcut Degil");
        require(!onayBekliyorMu(_kisiAddress), "Kisinin daha onceden onay bekleyen bir talebi vardir.");
        uint yeniId = id++;

        calismaBilgiListesi[_kisiAddress][yeniId].id = yeniId;
        calismaBilgiListesi[_kisiAddress][yeniId].talepEdilenKurum = _talepEdilenKurum;
        calismaBilgiListesi[_kisiAddress][yeniId].pozisyon = pozisyon;
        calismaBilgiListesi[_kisiAddress][yeniId].sektor = sektor;
        calismaBilgiListesi[_kisiAddress][yeniId].calismaTipi = calismaTipi;
        calismaBilgiListesi[_kisiAddress][yeniId].isAciklama = isAciklama;
        calismaBilgiListesi[_kisiAddress][yeniId].basTarih = basTarih;
        calismaBilgiListesi[_kisiAddress][yeniId].bitTarih = bitTarih;
        calismaBilgiListesi[_kisiAddress][yeniId].ulke = ulke;
        calismaBilgiListesi[_kisiAddress][yeniId].sehir = sehir;
        calismaBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.OnayBekliyor;

        onayBekleyenKisiler.push(_kisiAddress);
        kisiCalismaIdListesi[_kisiAddress].push(yeniId);
        emit CalismaBilgiTalepEdildiLog(_talepEdilenKurum, ulke, pozisyon, sektor);
    }

    function talepOnaylaCalismaBilgi(address _kisiAddress, uint _calismaBilgiId) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(onayBekleyenKisiVeIdMevcutMu(_kisiAddress, _calismaBilgiId), "Kisinin onay bekleyen bir talebi yoktur.");
        require(calismaBilgiListesi[_kisiAddress][_calismaBilgiId].talepEdilenKurum == msg.sender, "Sadece Talep edilen kurum onaylayabilir.");

        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].onayBilgi.adres = msg.sender;
        calismaBilgiListesi[_kisiAddress][_calismaBilgiId].onayBilgi.zaman = block.timestamp;
        silOnayBekleyenListe(_kisiAddress);
        emit CalismaTalebiOnaylandiLog(msg.sender, block.timestamp);
        return _calismaBilgiId;

    }

    function getirOnayBekleyenListe() public view returns (address[] memory){
        return onayBekleyenKisiler;
    }

    function getirKisininCalismaIdListe(address _kisiAddress) public view returns (uint[] memory){
        return kisiCalismaIdListesi[_kisiAddress];
    }

    function getirKisininCalismaBilgisi(address _kisiAddress, uint _id) public view returns (CalismaBilgi memory){
        return calismaBilgiListesi[_kisiAddress][_id];
    }
    
    function getirKisininCalismaListesi(address _kisiAddress) public returns (CalismaBilgi[] memory){
     uint[] memory idliste =  getirKisininCalismaIdListe(_kisiAddress);
    
        for (uint i = 0; i < idliste.length - 1; i++) {
             calismaBilgileri.push(getirKisininCalismaBilgisi(_kisiAddress,idliste[i]));
            }
        return calismaBilgileri;
    }

    function silOnayBekleyenListe(address _kisiAddress) private {

        require(onayBekleyenKisiler.length > 0, "Onay Bekleyen Listesi Bostur");

        if (onayBekleyenKisiler[onayBekleyenKisiler.length - 1] == _kisiAddress) {
            onayBekleyenKisiler.pop();
            return;
        }

        bool kisiVarMi = false;
        uint index;

        for (uint i = 0; i < onayBekleyenKisiler.length - 1; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress) {
                onayBekleyenKisiler[i] = onayBekleyenKisiler[i + 1];
                kisiVarMi = true;
                index = i;
            }
        }

        if (kisiVarMi == false) revert("Kisi Onay Bekleyen Listesinde Yoktur.");

        for (uint i = index; i < onayBekleyenKisiler.length - 1; i++) {
            onayBekleyenKisiler[i] = onayBekleyenKisiler[i + 1];
        }

        delete onayBekleyenKisiler[onayBekleyenKisiler.length - 1];
        onayBekleyenKisiler.pop();
    }

    function onayBekliyorMu(address _kisiAddress) private view returns (bool){
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress) {
                return true;
            }
        }
        return false;
    }

    function onayBekleyenKisiVeIdMevcutMu(address _kisiAddress, uint _calismaId) private view returns (bool){
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress
            && calismaBilgiListesi[_kisiAddress][_calismaId].id > 0
                && calismaBilgiListesi[_kisiAddress][_calismaId].onayBilgi.durum == OnayDurum.OnayBekliyor) {
                return true;
            }
        }
        return false;
    }
}