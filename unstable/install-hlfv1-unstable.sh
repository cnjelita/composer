ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� TZ �=�r�v�Mr����[�T>�W߱je��y�� �H|I�l_m340b���B�n�nU^ ��wȏ<G^ ��3�������kNծp��ӧ?N�9�O����̀b�;������`��=��0D�"��	��/���E�a�����q|4�� wO��ǲ�	�#ۄ]՚��(�W
]dZ���-a�a,dvUY;�7'����K���#�\�m�3̥�j6pZ��A��jd���)EQ;�i[.I `k���v���hһ�i�m����a��$ϓ��t6�^y |�"�*ЬY�x;�>�o#֠1�t��u	F�_��rp��'0{��)�ڪ��)�t��4ҰRLd����r�$��Åm�L�v(b�	ui.�L��Ss���f��Бb�N;2������{����j�ʼ�א��j�v���0���A�r�(ظ�W[����B�c��lä����F�i
'4�Ej��z�622�a���g�5d�)�p�g�萖cj����QvB!�r]�vGC�;1.��v׳'ŜV(�"�:j�4�T��dS�̡��s��y��|��8^������W`��t'�/.����R~v�͐J���i|M��A�])���P禶t�t�D]<�oK1��s�n�O�v��h����kFGv�0[t_��:t4o�@�62u�������e>�.���]�5�����н�A��X,2K�#0��¼@�?��G r�L��\��2�6�j�����5h5����d���@�_��������WO���z�
�&c�� �n>J����&Y1��	��w^:���[��5����@�WÿB����'�W���a���'��Y埋��������?V�����$��[�,�����J`-�_7L��TZ������K��/����X�'���(�k�_����us2P��#�rA.wS']�H� �h�l�����-�&�5!���86;-t�xf�z;���[�n��I&���m���7p��m�����;��P�4�*qb���Q؆�YAR��R,t�aN���^	�?MU�nѺ%,5M<_4q&��4�e�W�˪f(-�	�^{�24�t�E��V��dk�ܪ�j� 4��ڥGl��:  ����"	X�G����B�א���G�`J���ې�W���š��������'rep� �7_3����9�I�R�txYp��'��I�������*���1O ��@���a���-U� �k�Dm��p"����
[̰�e��Ϙ�s��n>��):|xƨu�h�G<� ��X�IH�x�@J� �>��І�ڛ�� � �!<aC޹�W�Rf�*�\��kf�^$�T�j�6�A�N�&��v���5zJnh��$�=��>;1�a�8�o�w��cX%�v	��~L�ʼ���2�T7lp�EfڮN��`|�zTy �3�е>�_�z���qLa��<V�6h�G.��զ��5���M�Q.sT
�G�Ґb�^SU����xX��i�>��� hg#��u�^���2����@�ɰy������	7��T�Iq�GY�<����*6�[/_�'j"�]��f��C����#*L���zk�Za��O&ҽ�~	����D������|�0E�GcyOu,�^����sk��J�ՓR#?����N꣙��m�44�!�nƄUWGsL���V~�Ϥ���OXM��^�t^J�G��_�҄�b����=�`k��z��Du��Vr�R��M���R�0���z�5{:�P-���_`�rڤ7j�_��U0^`�*d�f��41Eb	lm�gaf��r��RY*���ٜ|X)��zm�|<�����F�J���D-4����r����4(3���-؜Z��������`h�P�r&�; �5qt�]E&^� ��Z)�IY�':١c^��I���5�V8ύb'�Fa�g��a3����ѻ�n�H��7�?$\l��� �_��V5���aY�S��������@�4ڠ��H��������h�	��T���}���?�s��_,,��p���<�T���iU��i ��C]���2�m�k�si�"�
��u�=�;�Eb���U���&�R�`��?��G�"��x�_��*��̥�E�.������z�_	L����7tl����i��1U��D�m�׬ CL� ���䬋ƣ�_�������š�~���|7Q��D�l������ҾyvI<X$��[6jd���yJ��"3ez���;*܊��D
��8cfn�LX$���45C�	����l��Y��3ުŪ��<at�'�G7�B?�*��E�QC`�X#���'Μ�j��;c�S�t�[m��
6�����[�ۮ��\
Y�������p8­��U���?(�d�\��x!"6l�k)��S�*�񁻮�A8)��f<���C7� ��"|�	[Az�.���w��p�f�:Vd���V����@���O��Y�+�����Ü����'XMAJˍ7tý\�f����!��H΍�ht��8�Er|��܏���Qo��av 0 �o �Z �������M�'>��;��vߣ��s���;��}Aw�C���a���2�W''�C�j�W�����[`Dnx�E5ˍ�(|�J�c��͆=��*3$��G�F�͚���	yN7��IR�H�_�6���qy�T� �#�@�p!�V�*�����O?�0^����5u�!�V	�E���>�2������|t�����
�Q7�v�9��-��|$d��Ⱦ�����`Ŕ=&�"��R�X]��sL{�c�����M<\��q�0'_�}�f�{-��f׆�f�83�Q1{,���}�t��e�7�~�6�ASW�uL���a���n�Ǖ��i~����&[��!�!�r(��9%����qTW���0"N��䔰�)�ߎ�x��A����[-&)�+��R:��YH��6
-�x�^ A@�-�g* ��;m��ekH�F���D��Q�:�%�P�l#݇��@�(�&I3��&�?>��+�4�z&�
^&8S�4|aQ)� y����� �v���+����V#ݫ�X��0�n;����2A��쿈8�%����[	|���8�n�VM��	�?�b�)>��[���/x�����iAA�E'�_�	��_+�e��a�»x�C?NE��+F������?����eH|�4�nav�4�*�t�, W8�a�հ���4xM�Q���1��v�6�$���׸I��%Ƶ=��Xl���E6G��&�H�ugdmxV6��>�`�k����í���
�	u�%��������Y	�y�G���<��Eu�����M��E"�u��J���o�s��w�~�����?����������ǟQ��)�(ķ�
��b֫uQَǣ�j\�D"�Ĩ��â�x$竱�PݎD6��[���2��7��a�V�t4�9Ɗ����d{�x��&�$�2L[u������`��_�l���q"���wߌ�,�;�ұ6�y����f����&��0�_���x5���x���f���)"m���8?zo���y�.�TýSw_���z�_|��=���c��/�1[�c%�ѳ��� ��Z�iCKc�
r����ul?��}��Ź7?m1���|d�ه�7����e٣\�:����Bb�	9��r>�Mg�RY����\6��\$���lH�lBjd�R�9ԏ����P"�7��TCni�^�q��7βW��q{ʕ|�)H���W�D3�<>�]�WR1��cR�d+߬f�v5�ځ'�e�B��yJ9u���D杮��Ω�]�
ۗ�����0�r&�?����7�f�M�:+E.�w������+�B��N?hO���5�|����Y!W�r��pB�.h7H{��\$����KNSǅBF�>�\���8Һd"�_�<9�*�H�,���嗹�;�"���|�?=�\�7���\�%8�!�z'���O"�=W�h(���̥v��w�����D.��Ȕrb\jșd��ݓ�$.+%2���e��gZ��r��8���o������M�~8)�_'����qL+V�p_�O�ZIU#��Y��Km�K�����g���4z��r� '�x,0��TON�z2�{���#}�W�%���,]HR.i�Vղ�B+�ܗ���y�X"������A�����ic	���C�K��9Ux�ó��Iưex�אrr%�-$Ek�}�'�Ƈj����*9������X*A%���;�w��P#�(E��F;��_3҆܁r���ǜ�;��qn�rj?)�c�Z�R�v��t����1`�����`��Co�z����O����x�����G�����1���a�����J���e�� y��s�}+��x��'�����ՀOO�B7��|JS3�lf��Ҽ=:��z��P�B�㲽��ľ���j�}̜J�\���M�j�R���]p�X�JJR��&�B%_��*��4Lƞ_���f<���cF<nU��b�Ik(R9�2j#�<�+��$@E
�*N� �W�P%rM#�|�w���ܽ�����_����X ��(L��!!!k�_̱��e�$fY+�Y�Hb����eM$fY�Y�@b����e�#fY�Y�8b��F�L��W�w�2�?��Y����f�9����5<�2�?a������J�o�U٤��K�zr�t���Ra�㥤��*4$�z��NU`9�:wy�pB�^7:�~���t�%#�)��q���x�0$������l�n��Q�?���%���r����߀���s��o>A�}�b�}��ֱ@��7�G���?������4.>����� �4I���΋Z�yB��Ro�go�Y^]E�}��a��������f�bA �P]�U1k�IT��ZhC6�UI/j�F�>xq�,��!���_℞W���<��� RF����������PdK��Q,!D�\�^U�=�J�z_����↲2�6x ���~!ܛ;�?����,&��2��<��m�:y��̝���`�+:�dA�Q�M����K2H�U�}:]�x7�&��M!�N�3���=w�vL:�� �0�7UA�<`ԃ:}L���ZF����^���R���f����i�>��$b�lSE�-�=`��'u[��>F�{�[�V���Ʉ��>8*6/��r�J?�mAy,�[��^Ƞ}t���޳�8�d53;Eΰ;�w>4��0ߚn;��b[�Lg�N���t�l�Hg:����L;m�5��#���� n �!�����
����!n�""?N�\����]��V��Ȉ������13�.n|T�,� ������P��
�� �|P�\��]�3��ԝ}��ƈ]���;��?~��r1����+�x�idt���v�� v�����FNR.�Iȫ�Sr�Z�hs�X>�3�q����&L�G�Kr�\r���Jx�a^:�r'ùaFr�����B��\�2̳�I2�^���;��S����ڙ��/�&�i��s
���K�`�WD,t��\1�@�x �����0�!�ԇ�{Q�}e�-C�'g����G��9��o��K�J�U<j!���G��ǟ��ݐ�b�j���&�����f@�3�u]�X�=��\�T>����$X1!e��r�!Tj4�gh@ S�3R�~?� ��l�����HV�v�iSUC���a�,��r G�@% ǰ��u� n|�4��#̑6x�Nۡ�S7�C2$�Ir�v���1�*�iz������ȩe��bw�iC�l%A���Y�)��@Q0��"�ç�w�"�ݭ	�f}���:��z���^Y���*�m��S4����sy���d��E����_���_�?����������������?��o<����R�g�=�X����/�m�������v1�+�|;��g�
b Wҩ�J%b�DZV�TVM%S1�Jd��^�N�ɌB�t�2YZ��/IZ�܏������o��ԏ2���>�ӅS�<��'�3��N��n,�[��?�M���EaE����w��u�"�_oE���w�ߺ�������Z���E����{�O{�͑�{����ut���c�:W���L�u`�lQMZg-��#V��ój�^�3v����۞�G�D��+�=��@��>3�{"k���Q����؝�Q�NlQY1�x�Y�g��x�0m�Ճ4B,��܊)����1�%�!:��5�w&\���tG٥<2b������;������@U&=�2C'��G�����-ʣ�D�M9r�5��Y[l8NA�y8�_T�:���7ب&�u�JuX.3Z�ꨴdGJ�|-G-����3����]-nbX�j3�j��n�21X��y�:w�j��J������|��P3�S/FYνV�L�����L�@�y�q8g���-�Ag�+f����	^��Z��y��"m�3�9�#�[J:3��ׅsY���<�m|�5 �#h���,j��l�xM��E6c$Wz���h�D�Rz\guT�i9�pb�Z����-���f>�SRua�G�D�x��3�V3z�����_KM/�J^���3*a�J��,2t�5��L���ZBirH�b���HT#˞��T�ҍ��xyQ��?������V
��dϗ=J��[�ɞۉ��S�H���nL.�N���9�W��lkҥY|���.U��z�ۖZ���1�f�]�����-������m!�ȷ@��p%[;�R�9qL�O�S׋?O#~�]���l"�l���W'U�2�*`�V�K+Bʉ��Υ���l�"f|>�R�Q"�%��Ŷ8'?��L��R�JssRN3sΨ����G�z��mU���������h�I��+�,��.������#�D�"�����t�ut{������ߛ���߬DpC���[�/�Z�#O������#o�}%����;Q/_�;��z�.{���A�#�=ؖW#�D^
pY����Z��"�{'�_'B�\�}���x��݋|�^����Q�_���+��������W%Kgkl{Y�Ӎ����]��@z�2?�1M_���m��9y��p��D$�9q�Y����\�m��0�"\�Uwx�c]��́OD��s�*b�a�@*J[b$V�y�B`ׂCdY�����,���/�g�\�t�Mjj��NdS�D{~�dGT�:�	r�x��b��~4襘�HV{֤�؋n��2���d�/i�0)�T�!N$��r���X,��ϑ8��ux���ZX`%1�bT�a\P8���9��j��LTәV�p�;>H�mP0�!Z,�N�iڌ���#bCPj�"ñ<�3����N
2%Z��1�ԓtbxR��K�Ѻ5���M���$fչ>�cu�0ԃ�|\ng�D�'�F3:]
���*}`�7�%�R��@Q�wJQAh���\�3媥����?y��%��/���
r~��
27�|�HT�&N8���\gY9�n��&L�4.Hs����O��m��'w��gL�k���C�m�ꅛ�p"��\��3Ŷ�v�f�5`��5�S��Y�����Z)G�m�ޚ��U~�%�QV���u�\\�ׅ3�蹳a�[aR��y�"���2"㸊2�*�9�a�#�X��\�LFk�b��굄�勋�f�g������ĞF�l�\8�r��xAT7!�F]0"��N25��=VK��Pj)��L�K���wE��h4$H0'%2�b�?�u�O3��x��|3;�����\=ifJ����҉��Z��HH�,ׂD��G���DO�D*˖����G枯 1��	�E���[0b�����/L��|�0p9��R�}�B�׼��fi���{G�Ɂ�2�5��%�����N�Bl8�s�oәy��4�_H
L�٩D��]�*)��2�������:�Y�H��V��D�!PҭrG:������*հ�N]+ͣ�z��L�=nJAB,J[�7(,=(��Ki�R�./fTR9n3]�99�.j�|D$:�Rf� �0Y���\tb30��M-��*��\�XJ�n��mV9��_EL�^_�E�	u��!����7ª[P��ƛ���U�
t�_"�y�hC��E������Y������%-'j���kī�i�A�}�gX`�M}�Fފ��G������'O� �7�7p�u��j�U�z����k,:�8���>����z��+Q0No�5��ch&4!՞�Xf�����~p�^�&>�M����/|�d�7��ae�Z�jE���Ļ��S�({t�t-�c�=�%�ߋ��<�8�C�D��f������/��_����/����s7��H���\?Iz���_HN��U�wx����rja#Y%UO!03:��I�g�`P�"'`
F��݅�^ �5�����Y���uH�a�4���cv�T���v�	��ַ�O�7�kUamd�]�Y�����z�'x:f�,r��"�kjj�9���9�ш���B. wM����6�����n�#�q)l	�y��򇭇�Az����k1�l�04��S�Aj@=Sd1�Fv�T�.P}k�}�@�g�wA����#9�!�����]:!I�&��93r�B��:��<x:�~e掗<�}��� ���հm�	k��,�\�x@~��$�#=�	7�0<ޘ�I�5z��C���o]��P�F�s�0'�X���9F߃2���q!h�X�Ԉ��Q���5�\ f
��?9}�۶b��F�� {�u��`�l�N �uHn��1�����l��	7*��:��H`U�e`��y]3�֦���O�qH6LQ�E�o�Iը���D������k�1�n<����g��];���_m���ۦb�>�A��5$|�djZ����/��-��=�����lS��4�Zs�Y��a�*�7�����Đ`	84"uao@s-�q/b��N�D���'��I>'	���е�Ƴ3�p@a6x�OB�xl��9��6sZ�J�T5�e�Z�i�jJ#D�'(�dm.�f�~�%�����/���oC=��^ƀ%]C�}�/��mz���?�٩W�[���,�ה���l��7�b��6��^0BV����d�N�a#
H��p�{!�$mmBG)H��SӰ���G��8@4��)� ��5pcC��)�e�6�#��G�Ѯ
 ؉:�� ��P�1s�o����p�gP��j٥�+?�b�2ʅ"���kof��׫S�[ʺ��=\�8�
X�Wq6C�l�u5�}��-[͛/�y�H�O�
��u���tٸ_k"�߫[�CD�D��d��n��x�]H���#oD���jf����`�v�!e�Fp,��z�L��JU�qDN�v��ƍM{S7���b��~����l,K�9E�r���M4��E�Y��LS����d"2n1��n�+��0Vmǜ=���)?s�%Br�����G�W���V�w5���p���S��]qvm���O������x*�b��y<^��C�C�C�@(��\�dG�%�W�`�7��2�<�{�y�m��s�"#=��v/����;
6��1�@�*����{W�B�gy�|��׫�˂�^Y��y�z M+�O�d 9���*H��x��J�{=�O)�> -���,��}��M�D"�:PD[<`H�.��[n�-���r�Z� r�p�=��K>�)�ɣv����1!���0����@RY ��@��X"K+@�h5ы�,  �Jd�t,�ʨq +(��Ñ�d�DZ�@
�p`����N�↷�C�m�����������M{�M���Խ'��a�]낝�wd��b�7#�j���|�o0��r�P���#E�g��ل��W�k���֮b��F�BS�b�{����ɺ�����K.�]ѩS�5�{��.7�tx�	(�7�x_�@���N�;5'vT3ѾZԚ���nf2ƥ�s�I���������qb��}M�������v~���<Dp������� ٍ�Wl�\�����=Wm��B�pZ�������"#TrUn�ӥ	�g[�ͬ��)_�jU�"=����a4E���s0�NgcO�zh���D��B��r�(�ק�KFo-m����`�b�)媕�P8��R��8a��dt���Y���3�Tz���i58 ��$�\�mJ(�8���a�&�(g�z��"���9�����*�ȇ�l&�L	4���Q���=|g�Q�z		S����M⠓�u�D��8�������Fw#�n�ߚ�[֋���f+����u�X����[m�;%3�c����]�n|�gk����p;���V�����
EG*�*:E�~�����v�8`h��t���"���x���_��u<���c4���b���y���G�f��t*�b������;I]��{���y<wO�����r�ض��z�;'�P�N�Q!����zD<�;]Ye�r�3��+��A�����������  �����4�?p��"_�?'���(@��O��vI���ӂJ����/�u������	��6���_������������	��_K�5
LR$SA���v��)�EID� RQ��2�	L(�b�qB�t����O������;����_H���{}L��\��q����«Z[�6��z������]�7)��ixԃ�ӟ�Fݪo�����RH���ȭ<&�;��O��s��^>�&iЧ�Lp����j���d�ˆ��t�R�)%�q���馾о}�������p���u|��?��T�:�Ǡ�����S��Q������?��T������_�����z����q��A�?����֩]�[����\�)�>��	���(��D����\�9�^�y���O{�]��@�����������P�G�	Gu�Q���Ο�G=����$`��� ��ʀ��s�?,����� �GF���C��Q����E�[�s�����Z;�NEѫ�m��p��+����K%󟑥�_�?��O�gf?o�V�z���m��x��gY6�Of�����ϗ�Ob��?Q4q>/j��l��e��N�z��ܾl'�¤.{{jx�fQ,���趝Q�U�����h�G�ږǤ�����i������'�#s��`��
����~��`�$�6WN�,t���ܙ���t�e�9���w���I�g֞8I₻����jنU�8�&�s�T�9^D�Ǒ���rs%��M����|g�d�Nj��­�nI,���+��4 
)�j���s�?,�������Ö(�`�?��D���H��O��	�?���j�������_�g��_�n����?6����?
����O����!�����x��p��ï���D��d/�<m��"���z���ů��?��_���ϖ����x���뵼�P�'!}2�E2J���ʶ������K��d�i󆿑ʥ`�J�c(FVR�E��ն5�S�;Qvᆌ���۶�Oa=���>�-�|���� Ւ��|�g���Z�[�x��o߽�¾cLe���օ&LF�Y{�ӫD['��tnM��b3�]od�t�\�N_�R�U��x�b�/kFI,�ؐԳ�I�5\��?���G=��?`���ɹدw	�� ����8�?������H�I��4��(�8"y*�D.dE��$)LȄ�P�"1��	x!��0"���8FbB2!ጀ����4����ť㛳S��{�F��b]���E:m��Tc�ekְ��,l�_��;���#۟C}zr����Y�(u�$&ӎ���O=�����Q�b'hY�鹦y��;'�8��3.k��������^p���������_@շRp��C�WX�?��T���w����U����������v����k��(2�8����7��;;=Z�|qnR�/��a��>T�^=�\�mic��s�O��t�HUO>K�3���}\k�Э���J��;Z�|YD���ˤ����A����q��!�[�����h�;���p�������/����/������j�?�� �'w�������-��_��/����e쾩�ArX���I��\?M���ǳJ��_��e�c�/��ۚ�� �Ӄ?q �W?����U���E4�:U�v��g ��1]�}ϔ��~͘�����s��Z������4V3���M�ѵ��;�9���&pv;��z*%��ޜ�L����,��|灿e_^�m����Uog 8^C)-��Lo(W�Iȳ�80�Kr��e��n����e�k'�eId�(��.�v����R��	ǙZJMm���?6�Ǘ�V	e�����"���Ї&i��F]��K��&����$ՌΊX��v;d7Ŭۑse�H��]wg����~��Z�h��Fb�������A�ܦ2ރ8�?�}��X�(���@�����o�����N ��8������`�	H�v�a*������@C������a�?���v������QR�\�!Ɋ�1E'lDR<�J�@���0A�N���E)a��
� ������A��S��������~7<�/���&˩?�	.��PVO�]�S{;d/�m�k�K����}-o2�wv�;��+�铇mK<��>�Z2Jw�/�ݸK����.G�!O��P|=�����y���T���]�d����^p��S�� ������ۊ��_%�-P\�w��y���?
���.���@��A��a�;�����W��4}����?D ������	���G��3��P����[�7R��ۇ�jh��q]i��c!_��s��]*������[��)�3�߷ǈ���������.ˑ3��'?�T+>�f�w� �'š��;����Q����͸=�M�Q�VZ��|4}/��l6���s�|�ߔ�h��QXq����~nf�9��%�M�V�՞w�߮m+Ӿ��[Y��� (�"�~g^���f�&�t�;Rm�VN������L�tO5�-L�'T=ۆ�I�E�FR}��k�fp��y�P:�q=32�3���n��uc�o�(-I8��xh�z��UV����e�۲������=8��"��?8�W ������)��VZ��Fp��!����Ӱ�	��������P���q�o�( �%�n����C��:���ӏ��,���i���_���a�o�����$�?|���P�~iկx��������	8�?M���?��T����nU��_�����UQ���r�����\����������r�
���\���@���X�T����X����� �`�ÿ������Qw�_��@�&C*�����������?��T �����@������?@��_E��CT�����a��P�����C�������? �?���� �����?����_�g��_�n����?6���p�;��h�G�?��W��C�?����C���G=��?`���ɹدw	�� ����8�?�� �?�'�����D�Ô��!�T��4bC1�X�I���q@FKF%
�RBH�r���������OA�_��{}cx�����'/��u�8��@�&Y�܀�d$i���b���C���t�qb7G��q�В��7�}��e[�����g�7�7�4U�]��R]�ka��p>w����-��g�t����àK't�u�;�;Zk@&�D��kK��ݽ���p�����?�����~U�J����_u`����S������V�f|Bp�����W�����Sm�������Z'M�֬_����٠z��Y���K�7H�{��.�K����n75�|qМt<%	��	�,9Q����{������t�95�moki�.Co�II2�qж�Yo�s6�������!����Q�G����8���Wu������A��_����U����~�����}<o��������Oi���:Rw��;��(*�s���_�������ݬ����ߤ6���$�g���x��f�k�q.my�mM6aF�(���p;ʍVG}�<R�N6��~��̨��3~&_.{i�2�m��N�o������뒸�v���;}���t��[���5��R����������g�E�9,Х�Uϲ^b7�CEE�ߵ��Q$�q�q���zfq?,ɖ�FK8��VҬ陦��8dr16�A�8$����O��A�5;sߔs��c�ZI�`mPq6_�k�$��l�s��e��t�ᄭ��wV�'������[�����_R��������������P4\$��Q���0������?mt�/lAq�\�Y��A�Q����$u_�eA�Q�F���z�N�@�����Cx��c�� �?�����*���?,��t6�q.,JR:�4`��
\j�z�GC�ݗ�*��X�.��7���^j���~X��)�G��܏���5��z���[�_�.K�^R��[�򖹼m-!���d4�J}ɴ�׬��(孡�m��F�������D�3��.��&9��j!�#Z<��kd�~�6T��%wb�9eߡl~�y���,.���e�[Sb9�������{ʾ��r��zYK%�跟eM���'�9���>}&b-srEU�3l���lW�2H�~�*��}���6K�S��y�Z���,sf�dM��\����*cۜ�G�?��c�ԓ�K�]�\B��ZfdJ���tO�,��R��޹��^���y���Hr�ڢ���y����]�����	!G�<����KR�DTp}��#)%��͟O�H`)!�#."�P�����&�?
�����k��H������r���^.B���x7��m0;$�S��8#�驯$_�����_�
��rs+����|�����}G��#��� �G	̽���|�!�1(����?�����������-�|��{����SFg[�c>N���_0@����Ɨ�:��r������v?�gr�������x/���K��%�G|_��a��r��h	^��5m�K3���;:������4�I��/ɞ��ӈ��e�DŦY�O>+b:����v�����#ޛ�{I��~A�_��"׳\��fM�a4�[��Ngm�p�ӑlL��$���|�����޵6��m���
;7u�vy�y�C��t  �~?��ry�@�����m�N4';9���sT%1�Kk̵��3�4|`����	C.'�8D�0JC��z9�t�����Wt�&�ڜk���(��nc,/��檏�G�������y�ĭ���M)���J�n��2���2A$3~:���05�Rq����x��y����x^��`���������G�o�o��9�'��'�FS��ڡ3@aj����|��u��h^�9O�_�-�jA~T����k���b���Q��4����k����Ki<�jR�+<�����Y�?�e����l�A�AZ����?�U�����o�������i���TAey��6w��Pn�kg�������0lr�����序�]�}��[��D�4Ađ��@(5��ck![�屵������m�h!4.3WȏN]]f��ǥ+�����P\j�ծ+���y��pRJ��<���	����4:�T
��hV��n�h5��r�t��1>��*�p��΢�zV�)Z�v��~�Dg-��O��VSnXxl����?
���&�F��ς㻑�a���Ф6V�CʖX;쭕�+2c{[�x��[�����%�ye�ՏO���6�Twu}R��ld(��r0�{��g�
L9Z��YS�z��Vu@���d.��#k��1
�~�Ɨ
�cĀ�R��r����4���[�C�O*H���U��
���[���a���&�C"h�����:��)A�w*��O����O�����o��?ր�@.��}�<�?��g�����r�\��W�oq���� ����������A��E�^�+�|i|������� ��\����gJH������G�	���������0��
���d\0�{ ��g��~���?��,�|!��?���O�X��O9����i����?���� �������؍�_��HY�?(
��߷������ �#%���"$;�"��� 1�H�� ��� �0��/m������������9�������������S�?���?��C���7�`�'d��ǂ�����}�\�?y���RA>����B.�����������ȅ��h���Y꿥qo@�� ��o���/�W�?���r��:MกiefN�z�$z��� uS���2eL��u��MS����4�
Ɣh��>o�����/���?������'�ⰨP���_����6����R�IV��K<��:j��Ej26��Z4}Z��[ª�q�O_l�*���SQ���ս��v��{l2]=h�f�EGe:,En;,��Rm-�o�ۣtOU���Қ�n����]N�����m=�*��Q���%V��9޻���<g�C����!��?\��o����������%��?�!�n��E����3�?N����{b�N8��z1��?�Z����yf���5�_⿺0Z���`��t�ö�z�Ok
GwHL�h�*���vǴj%����\Q9�ZCi9�.���Ή��[h��S��C��Z��/��oFȲ������/�\�A�Wf��/����/�����������}��J����7���_�Y��[V�^`mԞY9����������K�r"7�pO[r_�@n��`�r���d�knz�.�aT�?�;��ߌUm4ok�Ȕ9�0.N�h\�2fΑSq�UbI�&�NS{Ķ�R�^I���j9��%�Z��6Y������W)"�*;�r��p��,�������2�h�q�a-�ޫ����(}>r~sSP��c�R�|��'ǚOd���ө�l}ǻ�.6�f�P�vŷ��z]��Q����r(��,��� �|6�/�����!��G�&�4�u	S۵���Z���{�<�?�����������S���k����(1��?��=r��̍�/�?���O/^z�A��=����������������@����e� w������Q��?� s��x�mq� ��Ϝ������
�����>�����������4 ��������\�?���/�T���� 3�����r����Cf���� �?}]��A�G*�f��)��P��?䰼o��p�cK`zzn�W�� ��=�O��X��V ?V��|��H>�3�I����I�^jۗ������n�	��.w����yZ)V��!.�H���}}^Y����i�謱�̩�:��k��O��Ìd��9>M֢b9�����_�G�~/e�ȍ�_UNk�cQ�a��T�GE�	Ui�ee�p�N�����tyb����_֙�eg"i����#�\N�<��0JC��z9�t�����Wt�&�ڜk���(��nc,/��檏�G����3`�����!s��b�����}�\�?��g�<���KH���o�a0��
�����������I������E��n�������r����r��7����F.����ߊ���$������o�5;d�+�GJ�4'�_j�_�~��I�ex���׽��/e
T�<��S@yl������v�,WU�����z^�ߔ�i�X/4��7�����W��4�����F	]<�Jt���}}Q��ƈ�z ��� $)���^�F=V���UѮ��ev_sېhWA�[fE[*{���*Z��9*��[R��Bw(v�ʝ���Q@M5s�w[�f��|��ȅ��o���_� s��i�[�>��}�<�	���X�O���B2�ZbL�Vu�RV�y	���4��p�0	+W
�MLe0ӤtCch�Rf�9M����+#�k�O��O?s��3c�閵�t�1'd$a��R�Ũ�&�^[1��1+������q3!���*ꞯ
~d�����j�HKJ�l�*�jk��+�����i�QB� 	����΢�`�>K��-����|-�����gvȴ�O�ʺ�y��!�����������"�q�uS�%����e���y��jl/D�#):ǐ*�$��k��V#[Dw�z\���%������[��*Yo�\r��ި�)��}aDM�҈�j� �[�iWj��b�mI�I��{hg�	��:Z������E>����/*������y���� p��E��e����/����/�����h�l��GQ%��[�o��?��[�豻�(Q��p��ܫ��{������j ��B /k �K+ة+����-��3
Z��j�j���Q����,ђ�����H���?�ץ�R���6�(Z/ϊ�m�[-xny�\�!���T6�u�t�x�r=�r\wXc�dL0���P�&�e� r�`��y"�~�ֽrYrá������67�0��4%��!���=���b#��r6QV�C}.��r�Ӿų^D�0�<�4a�nzJ�hy��3#����V�!{\Y�c���H���F!yJ,�6lz���B}D(�V�ͬ�|8%{xiZ��r�����D�F�9��Cxx]�����X�}��I���4p��-�-�_�������;�������m�� �\O�?����j��������oLge��_N�,��c'(|��Bor���,<|�}}����d����U�5V�S�_������I����[�������-�|@��}���$�<��}�7��p�x��{�NL���������㢚��pp���-�����7�?��aA]��'f����	���������ǻ���I^�|a{|���\u���_ə%_�
�m��������HU�����?
�����x|�����~�c�=����b������+���/�ǯ�"�Oz��]�Ǆ�<�秺��L����wϽ���<׫�m��N��
�ɍFj܄��/Ԏ�ᯌ�e���S7��)>�qu5>��<�rP������:�UX�L�j�� ��Ϲ�?`{���)�����{���'���f�����)����cG��ax_�_ݙK���;��9�C/x��c��_��/���)>l
7B��b0
���KN�5B���t��<�Xe�_����_���gw�!�����#���~�o�DYz�Ϯ."�U�	?��)��޽�a��~о���/kB               �R�Y�bo � 