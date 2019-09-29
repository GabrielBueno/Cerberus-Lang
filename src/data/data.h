#ifndef CERBERUS_DATA_H_
#define CERBERUS_DATA_H_

#include "data_type.h"
#include "../../token/token.h"

namespace Cerberus {
    class Data {
    public:
        static void with_type(DataType);
        static void with_data(Token);
        static Data make();

        

    private:
        Data(DataType, Token);
    };
}

#endif