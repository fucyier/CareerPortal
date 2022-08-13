// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
//pragma experimental ABIEncoderV2;
import "./BaseContract.sol";
contract CalismaBilgileri is BaseContract{
  uint public id;

    struct CalismaBilgi {
         uint id;
         address kurumAdres;
         uint32 pozisyon;
         uint8 sektor;
         CalismaTipi calismaTipi;
         string isAciklama;
         uint basTarih;
         uint bitTarih;
         uint8 ulke;
         uint32 sehir;
        }
       
         enum CalismaTipi { 
             YariZamanli, 
             TamZamanli, 
             Stajyer
             }

        mapping(address=>mapping(uint=>CalismaBilgi)) public calismaBilgileri;
      
       
        event CalismaBilgiEklendiLog(address _kisiAdres, address _kurumAdres, uint _pozisyon, uint _sektor);
        event CalismaBilgiGuncellendiLog(address _kisiAdres, address _kurumAdres, uint _pozisyon, uint _sektor);

         function ekleCalismaBilgi(address _kisiAddress, address kurumAdres, uint32 pozisyon, uint8 sektor, CalismaTipi calismaTipi, string memory isAciklama, uint basTarih, uint bitTarih, uint8 ulke, uint32 sehir)  public sadece_Uni_Firma_Kamu{
             require(kisiler[_kisiAddress].durum,"Student not exists");
             uint yeniId=id++;
             calismaBilgileri[_kisiAddress][yeniId].kurumAdres=kurumAdres;
             calismaBilgileri[_kisiAddress][yeniId].pozisyon=pozisyon;
             calismaBilgileri[_kisiAddress][yeniId].sektor=sektor;
             calismaBilgileri[_kisiAddress][yeniId].calismaTipi=calismaTipi;
             calismaBilgileri[_kisiAddress][yeniId].isAciklama=isAciklama;
             calismaBilgileri[_kisiAddress][yeniId].basTarih=basTarih;
             calismaBilgileri[_kisiAddress][yeniId].bitTarih=bitTarih;
             calismaBilgileri[_kisiAddress][yeniId].ulke=ulke;
             calismaBilgileri[_kisiAddress][yeniId].sehir=sektor;
           
             emit CalismaBilgiEklendiLog( _kisiAddress, kurumAdres,pozisyon, sektor);
    }
       function guncelleCalismaBilgi(address _kisiAddress, uint _calismaBilgiId, address kurumAdres, uint32 pozisyon, uint8 sektor, CalismaTipi calismaTipi, string memory isAciklama, uint basTarih, uint bitTarih, uint8 ulke, uint32 sehir)  public sadece_Uni_Firma_Kamu returns(uint){
             require(kisiler[_kisiAddress].durum,"Student not exists");
             
             calismaBilgileri[_kisiAddress][_calismaBilgiId].kurumAdres=kurumAdres;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].pozisyon=pozisyon;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].sektor=sektor;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].calismaTipi=calismaTipi;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].isAciklama=isAciklama;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].basTarih=basTarih;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].bitTarih=bitTarih;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].ulke=ulke;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].sehir=sektor;
           
             emit CalismaBilgiGuncellendiLog( _kisiAddress, kurumAdres, pozisyon, sektor);
             return _calismaBilgiId;

    }
     
}