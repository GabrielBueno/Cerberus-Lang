#ifndef CERBERUS_NUMBER_LITERAL_H_
#define CERBERUS_NUMBER_LITERAL_H_

#include <string>

namespace cerberus {
    class NumberLiteral {
    protected:
        NumberLiteral();
    };

    class IntegerLiteral : NumberLiteral {
    public:
        IntegerLiteral();
        IntegerLiteral(int data);

        int data();
        void set_data(int data);

    private:
        int _data;
    };

    class DoubleLiteral : NumberLiteral {
    public:
        DoubleLiteral();
        DoubleLiteral(double data);

        double data();
        void set_data(double data);

    private:
        double _data;
    };
}

#endif