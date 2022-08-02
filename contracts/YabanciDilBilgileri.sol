// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
import "./EgitimBilgileri.sol";

contract YabanciDilBilgileri{

     struct YabanciDil {
         Registration.OnaylayanKurum onayKurumTipi;
         address onayKurum;
         uint basTarih;
         uint bitTarih;
         EgitimBilgileri.OgretimTipi ogretimTipi;
         uint32 ogretimDili;

        }
        function addYabanciDil (address _onaylayanKurumTipi,address _onayKurum, uint _basTarih, uint _bitTarih,EgitimBilgileri.OgretimTipi _ogretimTipi,uint32 _ogretimDili) public {
        universities[_universityAddress] = Universite(true,_isim, _ulke);
            emit UniversityRegisteredLog( _universityAddress, _isim, _ulke);
    }





}