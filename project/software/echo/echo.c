#define RECV_CTRL (*((volatile unsigned int*)0x80000000) & 0x02)
#define RECV_DATA (*((volatile unsigned int*)0x80000004) & 0xFF)

#define TRAN_CTRL (*((volatile unsigned int*)0x80000000) & 0x01)
#define TRAN_DATA (*((volatile unsigned int*)0x80000008))

#define BYTE_BUFR (*((volatile unsigned char*)0x100001FF))

int main(void)
{
    for ( ; ; )
    {
        while (!RECV_CTRL) ;
        BYTE_BUFR = RECV_DATA;
        while (!TRAN_CTRL) ;
        TRAN_DATA = BYTE_BUFR;
    }

    return 0;
}
