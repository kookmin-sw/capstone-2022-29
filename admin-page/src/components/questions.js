import React, {useEffect, useState} from 'react'
import Table from './Table'
import axios from "axios";
import {Loading} from "./loading";  // new

const getData = async () => {
    const response = await axios({
        method: 'GET',
        url: `http://ec2-3-39-192-200.ap-northeast-2.compute.amazonaws.com:5000/qa`,
    });
    return response.data;
}


function Questions() {
    const [requestData, setRequestData] = useState([]);

    useEffect(() => {
        async function fetchRequest() {
            setRequestData(await getData())
        }
        fetchRequest();
    }, [])

    const RequestColumns = React.useMemo(() => [
        {
            Header: "title",
            accessor: 'title',
        },
        {
            Header: "Content",
            accessor: 'content',
        },
        {
            Header: "Contact",
            accessor: 'receiver',
        }
    ], [])

    if (!requestData) {
        return <Loading/>
    } else {
        return <>
            <header className="bg-white shadow">
                <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                    <h1 className="text-3xl font-bold text-gray-900">공지사항</h1>
                </div>
            </header>
            <div className="min-h-screen bg-gray-100 text-gray-900 pb-40">
                <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 pt-4">
                    <div className="mt-4">
                        <h1 className="text-3xl font-bold text-gray-900 mb-10">Q&A 목록</h1>
                        <Table list columns={RequestColumns} data={requestData}/>
                    </div>
                </main>
            </div>
        </>
    }
}

export default Questions;