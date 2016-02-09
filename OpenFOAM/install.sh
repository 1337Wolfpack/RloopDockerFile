echo '. /opt/OpenFOAM/OpenFOAM-3.0.1/etc/bashrc' >> $HOME/.bashrc
. $HOME/.bashrc
cd $WM_PROJECT_DIR
./Allwmake
cd $WM_THIRD_PARTY_DIR
sed -i 's/time make/make/g' makeCmake
./makeCmake
wmSET
cd $WM_THIRD_PARTY_DIR
./makeParaView4
cd $FOAM_UTILITIES/postProcessing/graphics/PV4Readers
wmSET
./Allwclean
./Allwmake
